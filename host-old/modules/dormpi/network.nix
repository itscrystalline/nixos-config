{
  config,
  pkgs,
  lib,
  secrets,
  ...
} @ inputs: let
  cfg = config.crystal.dormpi.network;
  mkDhcpLocks = list:
    lib.concatStringsSep " " (map ({
      mac,
      ip,
      hostname,
      lease ? "infinite",
    }: "${mac},${ip},${hostname},${lease}")
    list);
in {
  imports = [
    ../common/network.nix
  ];

  options.crystal.dormpi.network.enable = lib.mkEnableOption "dormpi network configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = "cwystaws-dormpi";
      networkmanager = {
        wifi.powersave = false;
        unmanaged = ["interface-name:wlan0"];
        settings = {
          connection.autoconnect-retries = -1;
        };
      };
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
        DHCP_HOSTS = mkDhcpLocks [
          {
            mac = "cc:40:85:b3:c9:a4";
            ip = "192.168.12.136";
            hostname = "desk-light";
          }
          {
            mac = "3c:6a:d2:be:4e:57";
            ip = "192.168.12.216";
            hostname = "kettle-switch";
          }
          {
            mac = "bc:07:1d:c4:0c:63";
            ip = "192.168.12.10";
            hostname = "fan-switch";
          }
        ];
        COUNTRY = "TH";
      };
    };

    services.haveged.enable = true;
  };
}
