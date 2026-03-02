{
  config,
  lib,
  ...
}: {
  options.network = {
    ports = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          tcp = lib.mkOption {
            type = lib.types.listOf lib.types.port;
          };

          tcpRange = lib.mkOption {
            type = lib.types.listOf (lib.types.attrsOf lib.types.port);
          };

          udp = lib.mkOption {
            type = lib.types.listOf lib.types.port;
          };

          udpRange = lib.mkOption {
            type = lib.types.listOf (lib.types.attrsOf lib.types.port);
          };
        };
      });
      description = "Lists of ports to open, seperated by TCP/UDP/both.";
    };
  };
  config = {
    users.users.${config.core.primaryUser}.extraGroups = ["networkmanager"];
    networking = {
      networkmanager.enable = true;
      hostName = config.core.name;
      firewall = with config.network.ports; {
        enable = true;
        allowedTCPPorts = tcp;
        allowedUDPPorts = udp;
        allowedTCPPortRanges = tcpRange;
        allowedUDPPortRanges = udpRange;
      };
    };
  };
}
