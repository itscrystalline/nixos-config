{
  config,
  lib,
  ...
}: {
  imports = [./network-mounts.nix];

  options.network = {
    dhcp = lib.mkEnableOption "DHCP" // {default = true;};
    trustedInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Trusted Network Interfaces.";
      default = [];
    };
    ports = {
      tcp = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        description = "TCP ports to open.";
        default = [];
      };
      tcpRange = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.port);
        description = "TCP port ranges to open.";
        default = [];
      };
      udp = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        description = "UDP ports to open.";
        default = [];
      };
      udpRange = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.port);
        description = "UDP port ranges to open.";
        default = [];
      };
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];
    networking = {
      networkmanager.enable = true;
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
