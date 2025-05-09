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

  networking.networkmanager.unmanaged = ["interface-name:wlan0"];
  services.hostapd = {
    enable = true;
    radios.wlan0 = {
      countryCode = "TH";
      channel = 11;
      # settings = {
      #   ieee80211n = true;
      #   wmm_enabled = true;
      # };
      networks.wlan0 = {
        ssid = "dormpi";
        authentication = {
          mode = "wpa2-sha256";
          # saePasswords = [{password = secrets.homeassistant.wifi-password;}];
          wpaPassword = secrets.homeassistant.wifi-password;
        };
      };
    };
  };

  networking.interfaces."wlan0".ipv4.addresses = [
    {
      address = "192.168.12.1";
      prefixLength = 24;
    }
  ];

  networking.firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
  services.haveged.enable = config.services.hostapd.enable;
}
