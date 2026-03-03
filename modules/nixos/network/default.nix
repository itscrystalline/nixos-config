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
    };
    ports = {
      tcp = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        description = "TCP ports to open.";
      };
      tcpRange = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.port);
        description = "TCP port ranges to open.";
      };
      udp = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        description = "UDP ports to open.";
      };
      udpRange = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.port);
        description = "UDP port ranges to open.";
      };
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];
    networking = {
      networkmanager.enable = true;
      hostName = config.core.name;
      useDHCP = config.network.dhcp;
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
