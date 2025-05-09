{
  config,
  pkgs,
  secrets,
  ...
} @ inputs: {
  imports = [
    ../common/network.nix
  ];

  networking = {
    hostName = "cwystaws-dormpi";
    networkmanager = {
      wifi.powersave = false;
      unmanaged = ["interface-name:wlan0"];
    };
    bridges.br0.interfaces = ["wlp1s0u1u1"];
    interfaces = {
      "wlan0".ipv4.addresses = [
        {
          address = "192.168.12.1";
          prefixLength = 24;
        }
      ];
      wlp1s0u1u1.macAddress = "ec:75:0c:af:44:6e";
      br0.macAddress = "ec:75:0c:af:44:6f";
    };
    firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };

  services.hostapd = {
    enable = true;
    radios.wlan0 = {
      countryCode = "TH";
      band = "2g";
      channel = 11;
      wifi4.capabilities = [
        "HT40+"
        "HT40-"
        "SHORT-GI-20"
        "SHORT-GI-40"
        "DSSS_CCK-40"
        "MAX-AMSDU-3839"
        "SMPS-STATIC"
      ];
      networks.wlan0 = {
        ssid = "dormpi";
        bssid = "eA:5f:01:76:93:a1";
        settings.bridge = "br0";
        authentication = {
          mode = "wpa2-sha1";
          wpaPassword = secrets.homeassistant.wifi-password;
        };
      };
    };
  };

  services.haveged.enable = config.services.hostapd.enable;
}
