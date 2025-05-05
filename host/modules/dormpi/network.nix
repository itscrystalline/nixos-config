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

  # "wlan0" is the hardware device, "wlan-station0" is for wifi-client managed by network manager, "wlan-ap0" is for hostap
  networking.wlanInterfaces = {
    "wlan-station0" = {device = "wlan0";};
    "wlan-ap0" = {
      device = "wlan0";
      mac = "08:11:96:0e:08:0a";
    };
  };
  #
  networking.networkmanager.unmanaged = ["interface-name:wlp*" "interface-name:wlan-ap0"];
  #
  services.hostapd = {
    enable = true;
    radios.wlan-ap0 = {
      countryCode = "TH";
      networks.wlan-ap0 = {
        ssid = "dormpi";
        authentication.saePasswords = with secrets; [{password = homeassistant.wifi-password;}]; # Use saePasswordsFile if possible.
      };
      channel = 11;
    };
  };

  networking.interfaces."wlan-ap0".ipv4.addresses = [
    {
      address = "192.168.12.1";
      prefixLength = 24;
    }
  ];

  # services.dnsmasq = {
  #   enable = true;
  #   settings = {
  #     interface = "wlan-ap0";
  #     # bind-interfaces = true;
  #     dhcp-range = ["192.168.12.10,192.168.12.254"];
  #   };
  #   # interface=wlan-ap0
  #   # bind-interfaces
  #   # dhcp-range=192.168.12.10,192.168.12.254,24h
  # };
  networking.firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
  services.haveged.enable = config.services.hostapd.enable;
}
