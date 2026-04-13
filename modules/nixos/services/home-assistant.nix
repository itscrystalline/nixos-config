{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) home-assistant;
  enabled = home-assistant.enable;
  catppuccin-homeassistant = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    rev = "0277ab8a42751bcf97c49082e4b743ec32304571";
    hash = "sha256-+pVH2Ee7xII6B+rR5tu/9XoRzYdhnWGFvEpBLpvkyI8=";
  };
in {
  options.crystals-services.home-assistant.enable = lib.mkEnableOption "Home Assistant";
  config = lib.mkIf enabled {
    sops.secrets."homeassistant-secrets.yaml" = {
      owner = config.systemd.services.home-assistant.serviceConfig.User;
      path = "/var/lib/hass/secrets.yaml";
      restartUnits = ["home-assistant.service"];
    };

    system.activationScripts.catppuccin-homeassistant = ''
      mkdir -p /var/lib/hass/themes
      cp ${catppuccin-homeassistant}/themes/catppuccin.yaml /var/lib/hass/themes/catppuccin.yaml
      chmod -R 0700 /var/lib/hass/themes
      chown -R hass:hass /var/lib/hass/themes
    '';

    services = {
      home-assistant = with config.secrets.homeassistant; {
        enable = true;
        package = pkgs.unstable.home-assistant.overrideAttrs (_: {doInstallCheck = false;});
        openFirewall = true;
        extraComponents = ["wiz" "matter" "mobile_app" "bluetooth" "tplink" "tplink_tapo" "accuweather"];
        customComponents = with pkgs.nur.repos.itscrystalline; [
          ha_tuya_ble
          hass-localtuya
        ];
        extraPackages = python3Packages:
          (with python3Packages; [
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
            latitude = "!secret latitude";
            longitude = "!secret longitude";
            name = "Dormitory";
          };
          zone = [
            {
              latitude = "!secret latitude";
              longitude = "!secret longitude";
              name = "Home";
              radius = 25;
              icon = "mdi:home";
            }
          ];
          http = {
            server_port = 8000;
            cors_allowed_origins = ["https://www.home-assistant.io"];
            use_x_forwarded_for = true;
            trusted_proxies = ["127.0.0.1"];
          };
          frontend.themes = "!include_dir_merge_named themes";
          automation = "!include automations.yaml";
          script = "!include scripts.yaml";
          scene = "!include scenes.yaml";
          default_config = {};
        };
        configWritable = true;
      };

      matter-server = {
        enable = true;
        port = 5590;
      };

      nginx.virtualHosts."dorm.${config.crystals-services.nginx.localSuffix}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.home-assistant.config.http.server_port}";
        proxyWebsockets = true;
      };
    };
  };
}
