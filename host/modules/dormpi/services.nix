{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: let
  catppuccin-homeassistant = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    rev = "0277ab8a42751bcf97c49082e4b743ec32304571";
    hash = "sha256-+pVH2Ee7xII6B+rR5tu/9XoRzYdhnWGFvEpBLpvkyI8=";
  };
in {
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
    package = pkgs.unstable.home-assistant.overrideAttrs (oldAttrs: {doInstallCheck = false;});
    openFirewall = true;
    extraComponents = ["wiz" "matter" "mobile_app" "bluetooth" "tplink" "tplink_tapo" "accuweather"];
    customComponents = [
      inputs.my-nur.packages.${pkgs.system}.ha_tuya_ble
      inputs.my-nur.packages.${pkgs.system}.hass-localtuya
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
        pyatv
        getmac
        samsungctl
        samsungtvws
        tuya-device-sharing-sdk
        tuya-iot-py-sdk
        xiaomi-ble
        websockets
        kegtron-ble
        ibeacon-ble
        spotifyaio
        aioelectricitymaps
        aiohttp-fast-zlib
        pyturbojpeg
        pycountry
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
      zone = [
        {
          inherit latitude longitude;
          name = "Home";
          radius = 25;
          icon = "mdi:home";
        }
      ];
      http.server_port = 8000;
      frontend = {
        themes = "!include_dir_merge_named themes";
      };
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";
      default_config = {};
    };
    configWritable = true;
  };
  system.activationScripts.catppuccin-homeassistant = ''
    mkdir -p /var/lib/hass/themes
    cp ${catppuccin-homeassistant}/themes/catppuccin.yaml /var/lib/hass/themes/catppuccin.yaml
    chmod -R 0700 /var/lib/hass/themes
    chown -R hass:hass /var/lib/hass/themes
  '';
  services.matter-server = {
    enable = true;
    port = 5590;
  };

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
