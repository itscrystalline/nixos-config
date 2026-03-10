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
  config = lib.mkIf enabled (let
    # Static settings that do not contain secrets – written to the Nix store.
    staticSettings = {
      INTERNET_IFACE = "wlp1s0u1u2";
      NO_VIRT = true;
      SSID = "dormpi";
      WIFI_IFACE = "wlan0";
      DHCP_HOSTS = mkDhcpLocks create-ap.dhcpLocks;
      COUNTRY = "TH";
    };
    # Config file without PASSPHRASE, placed in the Nix store.
    staticConf = pkgs.writeText "create_ap_static.conf" (lib.generators.toKeyValue {} staticSettings);
  in {
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

    # Pass the static settings to the NixOS module (without PASSPHRASE).
    services.create_ap = {
      enable = true;
      settings = staticSettings;
    };

    # Override the systemd service to inject PASSPHRASE at startup from the
    # sops-managed secret, keeping the passphrase out of the Nix store.
    systemd.services.create_ap = {
      after = ["sops-install-secrets.service"];
      serviceConfig = {
        RuntimeDirectory = "create_ap";
        ExecStartPre = [
          (pkgs.writeShellScript "create-ap-inject-passphrase" ''
            cp ${staticConf} /run/create_ap/runtime.conf
            chmod 600 /run/create_ap/runtime.conf
            printf 'PASSPHRASE=%s\n' \
              "$(cat ${config.sops.secrets."homeassistant-wifi-password".path})" \
              >> /run/create_ap/runtime.conf
          '')
        ];
        ExecStart = lib.mkForce "${pkgs.linux-wifi-hotspot}/bin/create_ap --config /run/create_ap/runtime.conf";
      };
    };

    services.haveged.enable = true;
  });
}
