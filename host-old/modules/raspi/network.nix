{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.raspi.network;
in {
  imports = [
    ../common/network.nix
  ];

  options.crystal.raspi.network.enable = lib.mkEnableOption "raspi network configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    networking.hostName = "cwystaws-raspi";
    networking.networkmanager.wifi.powersave = false;

    networking.firewall = {
      allowedTCPPorts = [80 443 2049 8080];
    };

    # nextcloud - collabora loopback
    # networking.hosts = {
    #   "127.0.0.1" = ["${config.services.nextcloud.hostName}" "${config.services.collabora-online.settings.server_name}"];
    #   "::1" = ["${config.services.nextcloud.hostName}" "${config.services.collabora-online.settings.server_name}"];
    # };
  };
}
