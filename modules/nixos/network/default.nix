{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption;
  inherit (config.secrets) known-networks;

  mkProfiles = list:
    builtins.listToAttrs (map (profile: (
        if (builtins.isString profile && (known-networks ? ${profile}))
        then {
          name = profile;
          value = known-networks.${profile};
        }
        else if (builtins.isAttrs profile && (profile.connection ? id))
        then {
          name = profile.connection.id;
          value = profile;
        }
        else builtins.throw "`profile` is not a well-known network profile name described in `config.secrets.known-networks`, or an attribute set describing one, containing the attribute `connection.id`."
      ))
      list);
in {
  imports = [./network-mounts.nix];

  options.network = {
    dhcp = mkEnableOption "DHCP" // {default = true;};
    trustedInterfaces = mkOption {
      type = types.listOf types.str;
      description = "Trusted Network Interfaces.";
      default = [];
    };
    ports = {
      tcp = mkOption {
        type = types.listOf types.port;
        description = "TCP ports to open.";
        default = [];
      };
      tcpRange = mkOption {
        type = types.listOf (types.attrsOf types.port);
        description = "TCP port ranges to open.";
        default = [];
      };
      udp = mkOption {
        type = types.listOf types.port;
        description = "UDP ports to open.";
        default = [];
      };
      udpRange = mkOption {
        type = types.listOf (types.attrsOf types.port);
        description = "UDP port ranges to open.";
        default = [];
      };
    };
    profiles = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      description = "NetworkManager profiles automatically configured via known-networks or inline attrsets. Profiles listed in sopsConnections are excluded automatically.";
      default = [];
    };
    sopsConnections = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "NetworkManager connection profiles managed via sops. Maps NM connection name to sops secret name. The secret value must be a complete NM keyfile; it is written to /etc/NetworkManager/system-connections/<name>.nmconnection at activation.";
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];

    # Declare a sops secret for every sopsConnections entry, writing the
    # full NM keyfile to /etc/NetworkManager/system-connections/<name>.nmconnection
    # with strict permissions so NetworkManager can read it.
    sops.secrets = lib.mapAttrs' (connName: secretName:
      lib.nameValuePair secretName {
        path = "/etc/NetworkManager/system-connections/${connName}.nmconnection";
        mode = "0600";
        owner = "root";
        group = "root";
      })
    config.network.sopsConnections;

    networking = {
      networkmanager.enable = true;
      # Exclude sops-managed profiles from ensureProfiles so they don't
      # overwrite the files written by sops at activation.
      networkmanager.ensureProfiles.profiles = mkProfiles (builtins.filter
        (p: !(builtins.isString p && builtins.hasAttr p config.network.sopsConnections))
        config.network.profiles);
      hostName = config.core.name;
      useDHCP = lib.mkDefault config.network.dhcp;
      firewall = with config.network.ports; {
        enable = true;
        inherit (config.network) trustedInterfaces;
        allowedTCPPorts = tcp;
        allowedUDPPorts = udp;
        allowedTCPPortRanges = tcpRange;
        allowedUDPPortRanges = udpRange;
      };
    };
  };
}
