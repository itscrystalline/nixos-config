{
  lib,
  config,
  pkgs,
  passthrough ? null,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.hm.nix) remoteBuilders asBuilderConfig;

  mkMachineEntry = b: "ssh://${b.user}@${b.hostName} ${builtins.concatStringsSep "," b.systems} ${b.privateKeyPath} ${toString b.maxJobs} ${toString b.speedFactor} ${builtins.concatStringsSep "," b.supportedFeatures}";

  machinesFile = pkgs.writeText "nix-machines" (
    builtins.concatStringsSep "\n" (map mkMachineEntry remoteBuilders) + "\n"
  );
in {
  options.hm.nix = {
    remoteBuilders = mkOption {
      type = types.listOf (types.submodule {
        options = {
          hostName = mkOption {
            type = types.str;
            description = ''
              Hostname or IP address of the remote builder.
              Must be reachable from this machine (LAN, Tailscale, etc.).
            '';
            example = "builder.local";
          };

          user = mkOption {
            type = types.str;
            default = "nixremote";
            description = ''
              The user to SSH into on the remote builder.
              Must be trusted in the builder's nix.settings.trusted-users.
            '';
          };

          privateKeyPath = mkOption {
            type = types.str;
            default = "/etc/nix/builder-key";
            description = ''
              Path to the *private* SSH key used to authenticate with the
              remote builder. Must be unencrypted (no passphrase).

              Generate with:
                ssh-keygen -t ed25519 -f /etc/nix/builder-key -N "" -C "nix-remote@$(hostname)"

              The public half must be added to the builder's authorized_keys
              (via `hm.asBuilderConfig.authorizedKeys` on the builder side).
            '';
          };

          publicKeyPath = mkOption {
            type = types.str;
            description = ''
              The SSH *host* public key of the remote builder.
              Written into ~/.ssh/known_hosts and also used to set
              StrictHostKeyChecking in the SSH match block for this builder.

              Find this by running on the builder:
                cat /etc/ssh/ssh_host_ed25519_key.pub
            '';
            example = "ssh-ed25519 AAAA...";
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = ["x86_64-linux"];
            description = "System types this builder can build for.";
            example = ["x86_64-linux" "aarch64-linux"];
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = "Maximum parallel builds to run on this builder.";
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = "Relative speed hint; higher values are preferred.";
          };

          supportedFeatures = mkOption {
            type = types.listOf types.str;
            default = ["nixos-test" "big-parallel" "kvm"];
            description = "Features declared by this builder.";
          };
        };
      });
      default = [];
      description = ''
        List of remote Nix builders to offload builds to.

        --- CLIENT SETUP CHECKLIST ---
        1. Generate a key for Nix to use:
             ssh-keygen -t ed25519 -f /etc/nix/builder-key -N "" -C "nix-remote@<this-host>"

        2. Add the public key to each builder's `hm.asBuilderConfig.authorizedKeys`.

        3. Get each builder's host public key for `publicKeyPath`:
             ssh-keyscan <builder-host> | grep ed25519

        4. Test:
             nix build --max-jobs 0 nixpkgs#hello
      '';
    };

    asBuilderConfig = mkOption {
      default = null;
      description = ''
        When set, configures this HM user to act as a remote Nix builder
        that other machines can offload builds to.

        An activation script manages the SSH authorized_keys entries.
        Note: system-level settings (trusted-users, system-features) must
        still be configured out-of-band (e.g. /etc/nix/nix.conf).

        --- BUILDER SETUP CHECKLIST ---
        1. Set `authorizedKeys` to the builder keys of all client machines.

        2. Ensure your user is trusted in /etc/nix/nix.conf:
             trusted-users = root <your-username>

        3. Make sure SSH is running and port 22 is reachable.

        4. Give clients your host public key:
             cat /etc/ssh/ssh_host_ed25519_key.pub
      '';
      type = types.nullOr (types.submodule {
        options = {
          authorizedKeys = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              SSH public keys of Nix clients permitted to use this machine
              as a builder. Each entry is the contents of the client's
              builder key (e.g. /etc/nix/builder-key.pub).
            '';
            example = ["ssh-ed25519 AAAA... nix-remote@client-host"];
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = [pkgs.stdenv.hostPlatform.system];
            description = "Systems this machine can natively build for.";
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = "Suggested maxJobs value for clients to use.";
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = "Suggested speedFactor value for clients to use.";
          };
        };
      });
    };
  };

  config = lib.mkIf (passthrough == null) (
    lib.mkMerge [
      (lib.mkIf (remoteBuilders != []) {
        programs.ssh.enable = true;

        hm.programs.ssh.hosts = builtins.listToAttrs (map (b: {
            name = "nix-builder-${b.hostName}";
            value = {
              inherit (b) user privateKeyPath publicKeyPath;
              hostname = b.hostName;
            };
          })
          remoteBuilders);

        nix.extraOptions = ''
          builders = @${machinesFile}
          builders-use-substitutes = true
          fallback = true
        '';

        home.activation.nixRemoteBuilderInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
          echo "Remote builders configured (${toString (builtins.length remoteBuilders)}):"
          ${builtins.concatStringsSep "\n" (map (b: ''
              echo "  ssh://${b.user}@${b.hostName} [${builtins.concatStringsSep "," b.systems}] jobs=${toString b.maxJobs} speed=${toString b.speedFactor}"
            '')
            remoteBuilders)}
        '';
      })

      (lib.mkIf (asBuilderConfig != null) {
        home.activation.remoteBuilderKeys = lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p "$HOME/.ssh"
          chmod 700 "$HOME/.ssh"
          AUTHKEYS="$HOME/.ssh/authorized_keys"
          touch "$AUTHKEYS"
          chmod 600 "$AUTHKEYS"

          ${builtins.concatStringsSep "\n" (map (key: ''
              if ! grep -qF ${lib.escapeShellArg key} "$AUTHKEYS" 2>/dev/null; then
                echo ${lib.escapeShellArg key} >> "$AUTHKEYS"
                echo "  Added builder key: ${lib.escapeShellArg key}"
              fi
            '')
            asBuilderConfig.authorizedKeys)}

          echo "This machine is configured as a remote builder:"
          echo "  Systems : ${builtins.concatStringsSep ", " asBuilderConfig.systems}"
          echo "  Max jobs: ${toString asBuilderConfig.maxJobs}"
          echo "  Speed   : ${toString asBuilderConfig.speedFactor}"
          echo "  NOTE: ensure your user is in trusted-users in /etc/nix/nix.conf"
        '';
      })
    ]
  );
}
