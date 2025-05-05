{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ../common/network.nix
  ];

  networking.hostName = "cwystaws-raspi";
  networking.networkmanager.wifi.powersave = false;

  # nextcloud - collabora loopback
  # networking.hosts = {
  #   "127.0.0.1" = ["${config.services.nextcloud.hostName}" "${config.services.collabora-online.settings.server_name}"];
  #   "::1" = ["${config.services.nextcloud.hostName}" "${config.services.collabora-online.settings.server_name}"];
  # };
}
