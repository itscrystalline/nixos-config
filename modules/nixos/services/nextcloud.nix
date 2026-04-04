{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) nextcloud;
  inherit (config.crystals-services.nginx) localSuffix;
  enabled = nextcloud.enable;
in {
  options.crystals-services.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain name for Nextcloud.";
    };
    folder = lib.mkOption {
      type = lib.types.str;
      description = "Main Nextcloud data directory.";
    };
    adminpassFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to a file containing the Nextcloud admin password.";
    };
    statsTokenFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to a file containing the Nextcloud serverinfo stats API token.";
    };
  };
  config = lib.mkIf enabled {
    # nextcloud-admin-password: only the nextcloud service user needs access.
    sops.secrets."nextcloud-admin-password".owner = "nextcloud";
    # nextcloud-admin-stats-token: readable by nextcloud (occ) and prometheus
    # exporter (different user). Mode 0444 is safe – this is a read-only token.
    sops.secrets."nextcloud-admin-stats-token".mode = "0444";

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      home = nextcloud.folder;
      hostName = nextcloud.domain;
      https = true;
      config = {
        dbtype = "mysql";
        adminpassFile = nextcloud.adminpassFile;
      };

      poolSettings = {
        pm = "dynamic";
        "pm.max_children" = "48";
        "pm.max_spare_servers" = "38";
        "pm.min_spare_servers" = "12";
        "pm.start_servers" = "12";
        "pm.max_requests" = "750";
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
        "opcache.enabled" = "true";
        "opcache.jit" = "on";
        "opcache.jit_buffer_size" = "128M";
      };

      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit news contacts calendar tasks recognize phonetrack memories previewgenerator notes groupfolders;
      };
      extraAppsEnable = true;

      settings = {
        updatechecker = false;
        default_phone_region = "TH";
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
        enabledPreviewProviders = [
          "OC\\Preview\\Image"
          "OC\\Preview\\Movie"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
        preview_imaginary_url = "http://127.0.0.1:${toString config.services.imaginary.port}";
        trusted_domains =
          [
            nextcloud.domain
            config.networking.hostName
            "nc.${localSuffix}"
            "100.125.37.13"
            "192.128.1.61"
          ]
          ++ config.services.nginx.virtualHosts.${nextcloud.domain}.serverAliases;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
          "2001:fb1:139:87b0:33d6:4f2:97b9:481e"
        ];
        "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
        "memories.exiftool_no_local" = true;
        "preview_ffmpeg_path" = "${lib.getExe pkgs.ffmpeg-headless}";
        "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
        "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
        "maintenance_window_start" = 7;
      };

      enableImagemagick = true;
      configureRedis = true;
      caching.redis = true;
      database.createLocally = true;
      maxUploadSize = "4G";
    };

    services.imaginary = {
      enable = true;
      settings.return-size = true;
    };

    services.nginx.virtualHosts.${nextcloud.domain} = {
      serverAliases = ["nc.${localSuffix}"];
      sslCertificate = "/mnt/main/cwystaws-raspi.snake-rudd.ts.net.crt";
      sslCertificateKey = "/mnt/main/cwystaws-raspi.snake-rudd.ts.net.key";
    };

    crystals-services.cloudflared.domains."nc" = {
      disableChunkedEncoding = true;
      noHappyEyeballs = true;
      noTLSVerify = true;
    };

    systemd.services.nextcloud-config = let
      inherit (config.services.nextcloud) occ;
    in {
      wantedBy = ["multi-user.target"];
      after = ["nextcloud-setup.service" "coolwsd.service" "sops-install-secrets.service"];
      requires = ["coolwsd.service" "sops-install-secrets.service"];
      script = ''
        ${occ}/bin/nextcloud-occ config:app:set serverinfo token --value "$(cat ${nextcloud.statsTokenFile})"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "nextcloud";
      };
    };

    systemd.services.mysql.serviceConfig.Restart = lib.mkForce "always";
    systemd.services.nextcloud-cron.path = [pkgs.perl];
  };
}
