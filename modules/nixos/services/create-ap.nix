{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) create-ap;
  enabled = create-ap.enable;
  mkDhcpLocks = list:
    lib.concatStringsSep " " (map ({
      mac,
      ip,
      hostname,
      lease ? "infinite",
    }: "${mac},${ip},${hostname},${lease}")
    list);
in {
  options.crystals-services.create-ap = {
    enable = lib.mkEnableOption "create_ap WiFi hotspot";
    dhcpLocks = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          mac = lib.mkOption {
            type = lib.types.str;
            description = "MAC address.";
          };
          ip = lib.mkOption {
            type = lib.types.str;
            description = "IP address.";
          };
          hostname = lib.mkOption {
            type = lib.types.str;
            description = "Hostname.";
          };
          lease = lib.mkOption {
            type = lib.types.str;
            description = "Lease time.";
            default = "infinite";
          };
        };
      });
      default = [];
      description = "List of static DHCP leases for the hotspot";
    };
  };
  config = lib.mkIf enabled {
    kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.all.forwarding" = 1;
    };

    nixpkgs.overlays = [
      (_final: prev: {
        linux-wifi-hotspot = prev.linux-wifi-hotspot.overrideAttrs (_final: _prev: {
          src = pkgs.fetchFromGitHub {
            owner = "lakinduakash";
            repo = "linux-wifi-hotspot";
            rev = "c0f153bff954542c5f0e551bfcad791f44ac345e";
            hash = "sha256-20yhcBhVlObl/aZKH4P2tdAeutTpZo+R0//i0/uAPFw=";
          };
        });
      })
    ];

    services.create_ap = {
      enable = true;
      settings = {
        INTERNET_IFACE = "wlp1s0u1u2";
        PASSPHRASE = config.secrets.homeassistant.wifi-password;
        NO_VIRT = true;
        SSID = "dormpi";
        WIFI_IFACE = "wlan0";
        DHCP_HOSTS = mkDhcpLocks create-ap.dhcpLocks;
        COUNTRY = "TH";
      };
    };

    services.haveged.enable = true;
  };
}
