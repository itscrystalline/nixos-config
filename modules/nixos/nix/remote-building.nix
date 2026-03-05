{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.nix) remoteBuilders asBuilderConfig;
in {
  options.nix = {
    remoteBuilders = mkOption {
      type = types.listOf (types.submodule {
        options = {
          hostName = mkOption {
            type = types.str;
            description = ''
              Hostname or IP address of the remote builder.
              Must be reachable by the local Nix daemon (which runs as root).
              Can be a LAN hostname, a tailscale address, or a public IP.
            '';
            example = "builder.local";
          };

          user = mkOption {
            type = types.str;
            default = "nixremote";
            description = ''
              The user to SSH into on the remote builder.
              This user must exist on the builder and be listed in
              its `nix.settings.trusted-users`.

              The corresponding SSH key (see `sshKey`) must be
              authorized for this user on the builder side.
            '';
          };

          sshKey = mkOption {
            type = types.str;
            default = "/etc/nix/builder-key";
            description = ''
              Path to the *private* SSH key used by the local Nix daemon
              to authenticate with the remote builder.

              IMPORTANT: This key must be:
                - Unencrypted (no passphrase) — the daemon cannot prompt for one
                - Readable by root (the daemon runs as root)
                - Generated separately from your personal SSH keys

              Generate with:
                ssh-keygen -t ed25519 -f /etc/nix/builder-key -N "" -C "nix-daemon@$(hostname)"

              The public half (/etc/nix/builder-key.pub) must be added to
              the builder's `nix.asBuilderConfig.authorizedKeys`.

              If managing this key with agenix or sops-nix, ensure it is
              decrypted and in place before the Nix daemon starts.
            '';
          };

          hostPublicKey = mkOption {
            type = types.str;
            description = ''
              The SSH *host* public key of the remote builder machine.
              This is added to the local known_hosts so the Nix daemon
              can connect without interactive confirmation.

              Find this by running on the builder:
                cat /etc/ssh/ssh_host_ed25519_key.pub

              Without this, the first build attempt will hang silently
              waiting for a host key confirmation that never comes.
            '';
            example = "ssh-ed25519 AAAA...";
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = ["x86_64-linux"];
            description = ''
              The system types this builder can build for.
              Must match what the builder actually supports — the Nix daemon
              will only route derivations whose system matches this list.

              For cross-compilation support, the builder must have
              `boot.binfmt.emulatedSystems` configured (via `emulatedSystems`
              in `asBuilderConfig` on the builder side).
            '';
            example = ["x86_64-linux" "aarch64-linux"];
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = ''
              Maximum number of builds to run in parallel on this builder.
              Should reflect the builder's CPU core count. The local daemon
              will not schedule more than this many concurrent jobs to this machine.
            '';
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = ''
              Relative speed hint used by the Nix daemon when choosing between
              multiple available builders. Higher values are preferred.
              A builder with speedFactor = 4 will be chosen over one with
              speedFactor = 1, all else being equal.
            '';
          };

          supportedFeatures = mkOption {
            type = types.listOf types.str;
            default = ["nixos-test" "big-parallel" "kvm"];
            description = ''
              Features the builder supports. Derivations that require a feature
              (e.g. `requiredSystemFeatures = [ "kvm" ]`) will only be routed
              to builders that declare that feature here.

              Common values:
                - "nixos-test"   — can run NixOS VM tests
                - "big-parallel" — has many cores, good for large parallel builds
                - "kvm"          — has KVM virtualisation available
                - "benchmark"    — stable environment suitable for benchmarking
            '';
          };
        };
      });
      default = [];
      description = ''
        List of remote Nix builders this machine should offload builds to.
        Setting any entries here automatically enables `nix.distributedBuilds`
        and configures SSH known hosts for each builder.

        --- CLIENT SETUP CHECKLIST ---
        1. Generate a daemon SSH key (once per client machine):
             ssh-keygen -t ed25519 -f /etc/nix/builder-key -N "" -C "nix-daemon@<this-host>"

        2. Copy the public key to each builder's authorizedKeys:
             On each builder, add the contents of /etc/nix/builder-key.pub
             to `nix.asBuilderConfig.authorizedKeys`.

        3. Get each builder's host public key for `hostPublicKey`:
             ssh-keyscan <builder-host> | grep ed25519

        4. Test the connection manually as root:
             sudo ssh -i /etc/nix/builder-key nixremote@<builder-host> nix --version

        5. Trigger a test build:
             nix build --max-jobs 0 nixpkgs#hello
             (max-jobs 0 forces all builds off-machine)
      '';
    };

    asBuilderConfig = mkOption {
      default = null;
      description = ''
        When set, configures this machine to act as a remote Nix builder
        that other machines can offload builds to.

        This creates a dedicated system user, authorizes client SSH keys,
        trusts the user with the Nix daemon, and optionally enables
        binfmt emulation for cross-platform builds.

        --- BUILDER SETUP CHECKLIST ---
        1. Enable this option and set `authorizedKeys` to the public keys
           of all client machines' daemon keys (/etc/nix/builder-key.pub).

        2. Ensure `crystals-services.ssh.enable = true` is effective
           (this module sets it automatically).

        3. Make sure port 22 is reachable from client machines
           (check firewall/security group rules).

        4. After deploying, give clients your host public key:
             cat /etc/ssh/ssh_host_ed25519_key.pub

        5. For cross-compilation, list target systems in `emulatedSystems`
           and ensure the kernel has binfmt support.
      '';
      type = types.nullOr (types.submodule {
        options = {
          user = mkOption {
            type = types.str;
            default = "nixremote";
            description = ''
              Name of the system user that remote clients SSH in as.
              This user is created automatically as a system user with
              no login shell beyond what Nix needs.
              Must match the `user` field set on each client's builder entry.
            '';
          };

          authorizedKeys = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              SSH public keys of Nix daemons on client machines that are
              permitted to use this machine as a builder.

              Each entry should be the contents of the client's
              /etc/nix/builder-key.pub (the daemon key, NOT a user key).

              Example entry:
                "ssh-ed25519 AAAA... nix-daemon@client-host"
            '';
            example = ["ssh-ed25519 AAAA... nix-daemon@my-laptop"];
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = [pkgs.stdenv.hostPlatform.system];
            description = ''
              Systems this machine can natively build for.
              Defaults to the host's own system type.
              Clients should list the same values in their `remoteBuilders.*.systems`.
            '';
            example = ["x86_64-linux"];
          };

          emulatedSystems = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Additional system types to support via binfmt emulation.
              Requires kernel binfmt support (enabled automatically via
              `kernel.emulatedArchitectures`).

              Use this to make an x86_64 machine build aarch64 packages,
              for example. Slower than native but avoids needing a separate
              ARM builder.
            '';
            example = ["aarch64-linux" "armv7l-linux"];
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = ''
              Informational only on the server side — controls the hint
              printed by the activation script. The actual limit seen by
              clients is set in their own `remoteBuilders.*.maxJobs`.
              Set this to match the machine's core count.
            '';
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = ''
              Informational only on the server side — printed by the
              activation script as a suggested value for clients to use
              in their `remoteBuilders.*.speedFactor`.
            '';
          };
        };
      });
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (remoteBuilders != []) {
      nix = {
        distributedBuilds = true;

        extraOptions = ''
          # Have the builder fetch from substituters itself rather than
          # the client uploading all dependencies — much faster on LAN.
          builders-use-substitutes = true
          # Fall back to building locally if all remote builders fail.
          fallback = true
        '';

        buildMachines =
          map (b: {
            inherit (b) hostName user systems maxJobs speedFactor supportedFeatures sshKey;
          })
          remoteBuilders;
      };

      programs.ssh.knownHosts = builtins.listToAttrs (map (b: {
          name = b.hostName;
          value.publicKey = b.hostPublicKey;
        })
        remoteBuilders);

      system.activationScripts.nixBuilderKeys = ''
        mkdir -p /etc/nix
        chmod 700 /etc/nix
      '';
    })

    (lib.mkIf (asBuilderConfig != null) {
      users.users.${asBuilderConfig.user} = {
        isSystemUser = true;
        group = asBuilderConfig.user;
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = asBuilderConfig.authorizedKeys;
      };
      users.groups.${asBuilderConfig.user} = {};

      nix.settings = {
        trusted-users = [asBuilderConfig.user];
        system-features =
          (lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ])
          ++ asBuilderConfig.systems;
      };

      crystals-services.ssh.enable = true;
      kernel.emulatedArchitectures = asBuilderConfig.emulatedSystems;

      system.activationScripts.remoteBuilderInfo = ''
        echo "Remote builder ready:"
        echo "  ssh://${asBuilderConfig.user}@<this-host> ${builtins.concatStringsSep "," asBuilderConfig.systems} - ${toString asBuilderConfig.maxJobs} ${toString asBuilderConfig.speedFactor}"
      '';
    })
  ];
}
