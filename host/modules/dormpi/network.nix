{
  config,
  pkgs,
  secrets,
  ...
} @ inputs: {
  imports = [
    ../common/network.nix
  ];

  networking.hostName = "cwystaws-dormpi";
  networking.networkmanager.wifi.powersave = false;

  # networking.networkmanager.unmanaged = ["interface-name:wlp*"];
  # services.hostapd = {
  #   enable = true;
  #   radios.wlp1s0u1u1 = {
  #     countryCode = "TH";
  #     channel = 11;
  #     settings = {
  #       ieee80211n = true;
  #       wmm_enabled = true;
  #     };
  #     networks.wlp1s0u1u1 = {
  #       ssid = "dormpi";
  #       authentication = {
  #         mode = "wpa2-sha256";
  #         # saePasswords = [{password = secrets.homeassistant.wifi-password;}];
  #         wpaPassword = secrets.homeassistant.wifi-password;
  #       };
  #     };
  #   };
  # };
  #
  # networking.interfaces."wlp1s0u1u1".ipv4.addresses = [
  #   {
  #     address = "192.168.12.1";
  #     prefixLength = 24;
  #   }
  # ];

  networking.firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
  # services.haveged.enable = config.services.hostapd.enable;
}
