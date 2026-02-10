{
  config,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.desktop.network;
in {
  imports = [
    ../common/network.nix
  ];
  options.crystal.desktop.network.enable = lib.mkEnableOption "desktop network";

  config = lib.mkIf cfg.enable {
    networking.useDHCP = lib.mkDefault true;
    networking.hostName = "cwystaws-meowchine";

    # Valent (KDE Connect)
    networking.firewall = rec {
      trustedInterfaces = ["p2p-wl+"];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPorts = [7236 7250 8475 3000];
      allowedUDPPortRanges = allowedTCPPortRanges;
      allowedUDPPorts = allowedTCPPorts;
    };
  };
}
