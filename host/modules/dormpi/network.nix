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
    # bridges.br0.interfaces = ["wlp1s0u1u1"];
    # interfaces = {
    #   "wlan0".ipv4.addresses = [
    #     {
    #       address = "192.168.12.1";
    #       prefixLength = 24;
    #     }
    #   ];
    #   wlp1s0u1u1.macAddress = "ec:75:0c:af:44:6e";
    #   # br0.macAddress = "ec:75:0c:af:44:6f";
    # };
    # firewall.allowedUDPPorts = [53 67]; # DNS & DHCP
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };

  nixpkgs.overlays = [
    (final: prev: {
      linux-wifi-hotspot = prev.linux-wifi-hotspot.overrideAttrs (
        final: prev: {
          src = pkgs.fetchFromGitHub {
            owner = "lakinduakash";
            repo = "linux-wifi-hotspot";
            rev = "c0f153bff954542c5f0e551bfcad791f44ac345e";
            hash = "sha256-20yhcBhVlObl/aZKH4P2tdAeutTpZo+R0//i0/uAPFw=";
          };
        }
      );
    })
  ];
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "wlp1s0u1u2";
      PASSPHRASE = secrets.homeassistant.wifi-password;
      NO_VIRT = true;
      SSID = "dormpi";
      WIFI_IFACE = "wlan0";
      DHCP_HOSTS = "cc:40:85:b3:c9:a4,wiz-light1,192.168.12.136,infinite";
      COUNTRY = "TH";
    };
  };

  # services.hostapd = {
  #   enable = true;
  #   radios.wlan0 = {
  #     countryCode = "TH";
  #     band = "2g";
  #     channel = 11;
  #     wifi4.capabilities = [
  #       "HT40+"
  #       "HT40-"
  #       "SHORT-GI-20"
  #       "SHORT-GI-40"
  #       "DSSS_CCK-40"
  #       "MAX-AMSDU-3839"
  #       "SMPS-STATIC"
  #     ];
  #     networks.wlan0 = {
  #       ssid = "dormpi";
  #       bssid = "eA:5f:01:76:93:a1";
  #       settings.bridge = "wlp1s0u1u1";
  #       authentication = {
  #         mode = "wpa2-sha1";
  #         wpaPassword = secrets.homeassistant.wifi-password;
  #       };
  #     };
  #   };
  # };

  services.haveged.enable = true;
}
