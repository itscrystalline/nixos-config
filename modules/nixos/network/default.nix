{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption;
  known-networks = import ./known-networks.nix;

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
    unmanagedInterfaces = mkOption {
      type = types.listOf types.str;
      description = "Network interfaces that NetworkManager will not manage.";
      example = ["end0"];
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
      description = "NetworkManager profiles automatically configured via known-networks or inline attrsets.";
      default = [];
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];

    networking = {
      networkmanager = {
        enable = true;
        unmanaged = config.network.unmanagedInterfaces;
        connectionConfig."connection.auth-retries" = 0;
        ensureProfiles = {
          profiles = mkProfiles config.network.profiles;
          environmentFiles = [config.sops.secrets."wifi-passwords".path];
        };
      };
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
