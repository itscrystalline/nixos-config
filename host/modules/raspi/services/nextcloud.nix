{
  config,
  pkgs,
  lib,
  ...
}: {
  services.cloudflared = let
    secret_path = builtins.toPath ../../../secrets/cfd_creds.json;
  in {
    enable = true;
    tunnels = {
      "fc4d0058-a84e-4ef5-b66f-56c2a1a7eb7f" = {
        credentialsFile = "${secret_path}";
        default = "http_status:404";
      };
    };
  };
  services.nextcloud = let
    pass = builtins.toPath ../../../secrets/nc_password.txt;
    domain = "nc.iw2tryhard.dev";
  in {
    enable = true;
    package = pkgs.nextcloud30;
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
      "pm.max_children" = "75";
      "pm.max_spare_servers" = "50";
      "pm.min_spare_servers" = "25";
      "pm.start_servers" = "25";
      "pm.max_requests" = "750";
    };
    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.enabled" = "true";
      "opcache.jit" = "on";
      "opcache.jit_buffer_size" = "128M";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit news contacts calendar tasks recognize phonetrack memories previewgenerator notes groupfolders notify_push richdocuments;
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
      trusted_domains = [
        "${domain}"
        "${config.networking.hostName}"
        "nc.crys"
        "100.125.37.13"
        "192.128.1.61"
      ];
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
      enable = true;
      # bendDomainToLocalhost = true;
    };
    enableImagemagick = true;
    configureRedis = true;
    database.createLocally = true;
    maxUploadSize = "4G";
  };
  services.imaginary = {
    enable = true;
    settings = {
      return-size = true;
    };
  };
  services.collabora-online = {
    enable = true;
    port = 9980; # default
    settings = {
      # Rely on reverse proxy for SSL
      ssl = {
        enable = false;
        termination = false;
      };

      # Listen on loopback interface only, and accept requests from ::1
      net = {
        listen = "loopback";
        post_allow.host = ["::1"];
      };

      # Restrict loading documents from WOPI Host nextcloud.example.com
      storage.wopi = {
        "@allow" = true;
        host = ["${config.services.nextcloud.hostName}"];
      };

      # Set FQDN of server
      server_name = "collabora.iw2tryhard.dev";
    };
  };
  services.nginx = {
    virtualHosts.${config.services.nextcloud.hostName}.serverAliases = "nc.crys";
    virtualHosts.${config.services.collabora-online.settings.server_name} = {
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
        proxyWebsockets = true; # collabora uses websockets
      };
    };
  };
  # collabora setup; https://diogotc.com/blog/collabora-nextcloud-nixos/
  systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url = "http://[::1]:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://${config.services.collabora-online.settings.server_name}";
    wopi_allowlist = lib.concatStringsSep "," [
      "127.0.0.1"
      "::1"
    ];
  in {
    wantedBy = ["multi-user.target"];
    after = ["nextcloud-setup.service" "coolwsd.service"];
    requires = ["coolwsd.service"];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
      ${occ}/bin/nextcloud-occ richdocuments:setup
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
  };

  systemd.services.mysql.serviceConfig.Restart = lib.mkForce "always";
}
