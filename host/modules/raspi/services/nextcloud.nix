{
  config,
  pkgs,
  lib,
  secrets,
  ...
}: {
  services.nextcloud = let
    pass = "${pkgs.writeText "nc_password" secrets.nextcloud.admin.password}";
    domain = "nc.iw2tryhard.dev";
  in {
    enable = true;
    package = pkgs.nextcloud31;
    home = "/mnt/main/nextcloud";
    hostName = domain;
    https = true;
    config = {
      dbtype = "mysql";
      adminpassFile = pass;
    };

    # https://spot13.com/pmcalculator/
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
        # "OC\\Preview\\BMP"
        # "OC\\Preview\\GIF"
        # "OC\\Preview\\JPEG"
        # "OC\\Preview\\PNG"
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
      preview_imaginary_url = "http://127.0.0.1:${builtins.toString config.services.imaginary.port}";
      trusted_domains =
        [
          "${domain}"
          "${config.networking.hostName}"
          "nc.crys"
          "100.125.37.13"
          "192.128.1.61"
        ]
        ++ config.services.nginx.virtualHosts.${domain}.serverAliases;
      trusted_proxies = [
        "127.0.0.1"
        "::1"
        "2001:fb1:139:87b0:33d6:4f2:97b9:481e"
      ];
      # "overwrite.cli.url" = "https://${domain}/";
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
      "memories.exiftool_no_local" = true;
      "preview_ffmpeg_path" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
      "maintenance_window_start" = 7;
    };

    notify_push = {
      # enable = true;
      # bendDomainToLocalhost = true;
    };
    enableImagemagick = true;
    configureRedis = true;
    caching.redis = true;
    database.createLocally = true;
    maxUploadSize = "4G";
  };
  services.imaginary = {
    enable = true;
    settings = {
      return-size = true;
    };
  };
  services.nginx = {
    virtualHosts.${config.services.nextcloud.hostName} = {
      serverAliases = ["nc.crys"];
      sslCertificate = "/mnt/main/cwystaws-raspi.snake-rudd.ts.net.crt";
      sslCertificateKey = "/mnt/main/cwystaws-raspi.snake-rudd.ts.net.key";
    };
    # virtualHosts.${config.services.collabora-online.settings.server_name} = {
    #   locations."/" = {
    #     proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
    #     proxyWebsockets = true; # collabora uses websockets
    #   };
    # };
  };
  # collabora setup; https://diogotc.com/blog/collabora-nextcloud-nixos/
  systemd.services.nextcloud-config = let
    inherit (config.services.nextcloud) occ;
    admin_token = secrets.nextcloud.admin.stats_token;
  in {
    wantedBy = ["multi-user.target"];
    after = ["nextcloud-setup.service" "coolwsd.service"];
    requires = ["coolwsd.service"];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set serverinfo token --value ${admin_token}
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
  };

  systemd.services.mysql.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.nextcloud-cron.path = [pkgs.perl];
}
