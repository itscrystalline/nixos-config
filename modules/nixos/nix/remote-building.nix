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
            description = "The hostname of the remote builder.";
          };

          user = mkOption {
            type = types.str;
            default = "nixremote";
            description = "Nix remote builder username.";
          };

          sshKey = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Path to private SSH key readable by the nix daemon (root). If not defined, will pull the sops secret `{remote-hostname}-builder-key-{local-hostname}`.";
          };

          hostPublicKey = mkOption {
            type = types.str;
            description = "SSH host public key of the builder, for known_hosts";
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = ["x86_64-linux"];
            description = "Architectures this remote builder supports building for.";
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = "Max CPU cores for building.";
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = "idk for this one";
          };

          supportedFeatures = mkOption {
            type = types.listOf types.str;
            default = ["nixos-test" "big-parallel" "kvm"];
            description = "Supported nix features on this builder.";
          };
        };
      });
      default = [];
      description = "Remote builders available to this machine.";
    };
    asBuilderConfig = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          user = mkOption {
            type = types.str;
            default = "nixremote";
            description = "User that clients SSH in as to perform builds";
          };

          authorizedKeys = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "SSH public keys of machines allowed to use this builder";
          };

          systems = mkOption {
            type = types.listOf types.str;
            default = [pkgs.stdenv.hostPlatform.system];
            description = "Systems this machine can build for";
          };

          emulatedSystems = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra systems to support via binfmt emulation (e.g. aarch64-linux)";
            example = ["aarch64-linux" "armv7l-linux"];
          };

          maxJobs = mkOption {
            type = types.int;
            default = 4;
            description = "Max parallel build jobs to accept";
          };

          speedFactor = mkOption {
            type = types.int;
            default = 1;
            description = "Relative speed hint for client scheduling (higher = preferred)";
          };
        };
      });
      default = null;
      description = "Configure this machine as a remote builder.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (remoteBuilders != []) {
      config.sops.secrets = builtins.listToAttrs (map (b: {
          name = "${b.hostName}-builder-key-${config.core.name}";
          value.mode = "0755";
        })
        (builtins.filter (b: b.sshKey == null) remoteBuilders));

      nix = {
        distributedBuilds = true;

        extraOptions = ''
          builders-use-substitutes = true
          fallback = true
        '';

        # Wire up all builders
        buildMachines =
          map (b: {
            inherit (b) hostName systems maxJobs speedFactor supportedFeatures;
            sshKey =
              if b.sshKey != null
              then b.sshKey
              else config.sops.secrets."${b.hostName}-builder-key-${config.core.name}".path;
            sshUser = b.user;
          })
          remoteBuilders;
      };

      # Trust the host keys so the daemon doesn't hang on first connect
      programs.ssh.knownHosts = builtins.listToAttrs (map (b: {
          name = b.hostName;
          value.publicKey = b.hostPublicKey;
        })
        remoteBuilders);
    })

    (lib.mkIf (asBuilderConfig != null) {
      users.users.${asBuilderConfig.user} = {
        isSystemUser = true;
        group = asBuilderConfig.user;
        shell = pkgs.bash;
        home = "/var/lib/${asBuilderConfig.user}";
        createHome = true;
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
