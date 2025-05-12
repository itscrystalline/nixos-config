{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: {
  imports = [
    ../common/services.nix
    ../../services/adguardhome.nix
  ];

  adguard = {
    enable = false;
    rewriteList = {
      "*.dorm".answer = "100.122.114.13";
    };
  };
  services.adguardhome.settings.dhcp = {
    enabled = false;
    interface_name = "wlan0";
    local_domain_name = "dorm";
    dhcpv4 = {
      gateway_ip = "192.168.12.1";
      subnet_mask = "255.255.255.0";
      range_start = "192.168.12.10";
      range_end = "192.168.12.254";
      lease_duration = 86400;
      icmp_timeout_msec = 1000;
      options = [];
    };
    dhcpv6 = {
      range_start = "";
      lease_duration = 86400;
      ra_slaac_only = false;
      ra_allow_slaac = false;
    };
  };

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.hardware.argonone.enable = true;
  environment.etc = {
    "argononed.conf".text = ''
      fans = 30, 60, 100
      temps = 45, 60, 70

      hysteresis = 5
    '';
  };

  hardware.bluetooth = {
    enable = true;
  };
  services.home-assistant = with secrets.homeassistant; {
    enable = true;
    openFirewall = true;
    extraComponents = ["wiz" "matter" "mobile_app" "bluetooth" "tplink" "tplink_tapo" "accuweather" "my" "analytics"];
    customComponents = with pkgs.home-assistant-custom-components; [
      localtuya
      # (localtuya.overrideAttrs
      #   (final: prev: rec {
      #     owner = "xZetsubou";
      #     domain = "hass-localtuya";
      #     version = "2025.5.1";
      #     src = pkgs.fetchFromGitHub {
      #       inherit owner;
      #       repo = domain;
      #       rev = version;
      #       hash = "sha256-cYaMHh16dmjO8UrpBZScGoHDNqvmQ5ceAq/lP6qazxA=";
      #     };
      #   }))
    ];
    extraPackages = python3Packages:
      (with python3Packages; [
        # postgresql support
        psycopg2
        numpy
        zeroconf
        aiohomekit
        aiodhcpwatcher
        pywizlight
        aiodiscover

        aiohttp-zlib-ng
        pyturbojpeg
      ])
      ++ (with pkgs; [
        zlib-ng
        libjpeg
      ]);
    config = {
      homeassistant = {
        inherit latitude longitude;
        name = "Dormitory";
      };
      http.server_port = 8000;
      frontend = {
        themes = "!include_dir_merge_named themes";
      };
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";
      mobile_app = {};
      bluetooth = {};
    };
    configWritable = true;
  };
  services.matter-server = {
    enable = true;
  };

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
