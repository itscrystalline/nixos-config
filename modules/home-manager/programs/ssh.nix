{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.hm.programs.ssh) hosts;

  selectName = name: hostname:
    if (hostname != null)
    then hostname
    else name;

  matches =
    builtins.mapAttrs (name: {
      hostname ? null,
      user,
      privateKeyPath,
      ...
    }: {
      hostname = selectName name hostname;
      identityFile = privateKeyPath;
      inherit user;
    })
    hosts;
in {
  options.hm.programs.ssh = {
    hosts = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          hostname = mkOption {
            type = types.nullOr types.str;
            description = "Hostname to connect to via SSH.";
          };
          user = mkOption {
            type = types.nullOr types.str;
            description = "User to connect to via SSH.";
          };
          publicKeyPath = mkOption {
            type = types.str;
            description = "Path to the public key on the host file system.";
          };
          privateKeyPath = mkOption {
            type = types.str;
            description = "Path to the private key on the host file system.";
          };
        };
      });
      description = "Hosts to configure SSH for. Automatically adds them to matchBlocks and known_hosts.";
    };
  };
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks =
        {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        }
        // matches;
    };
    home.activation = {
      sshKnownHosts = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/.ssh"
        touch "$HOME/.ssh/known_hosts"
        chmod 600 "$HOME/.ssh/known_hosts"
          ${builtins.concatStringsSep "\n" (map ({
            name,
            value,
          }: let
            actualName = selectName name value.hostname;
          in ''
            if ! grep -qF ${lib.escapeShellArg actualName} "$HOME/.ssh/known_hosts" 2>/dev/null; then
              echo ${lib.escapeShellArg "${actualName} ${value.publicKeyPath}"} >> "$HOME/.ssh/known_hosts"
            fi
          '')
          (lib.attrsToList hosts))}
      '';
    };
  };
}
