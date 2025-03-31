{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/services.nix
    ./docker.nix

    (inputs.nixpkgs-unstable + "/nixos/modules/services/hardware/scanservjs.nix")
  ];

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [gutenprint];
    extraConf = ''
      DefaultPaperSize A4
    '';
  };

  # REMOVE: once scanservjs gits into stable
  nixpkgs.overlays = [
    (final: prev: {
      scanservjs = pkgs.unstable.scanservjs;
    })
  ];
  services.scanservjs = {
    enable = true;
    settings.host = "0.0.0.0";
  };

  services.hardware.argonone.enable = true;
  environment.etc = {
    "argononed.conf".text = ''
      fans = 30, 50, 70, 100
      temps = 45, 55, 65, 70

      hysteresis = 5
    '';
  };

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
    pass = ./. + "../../../secrets/nc_password.txt";
  in rec {
    enable = true;
    package = pkgs.nextcloud30;
    home = "/mnt/main/nextcloud";
    hostName = "nc.iw2tryhard.dev";
    https = true;
    config = {
      dbtype = "mysql";
      adminpassFile = "${pass}";
    };
    nginx.recommendedHttpHeaders = true;

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
      "opcache.enabled" = "true";
      "opcache.jit" = "on";
      "opcache.jit_buffer_size" = "128M";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit news contacts calendar tasks recognize phonetrack memories previewgenerator notes groupfolders richdocuments;
    };
    extraAppsEnable = true;

    settings = {
      # mail_smtpmode = "sendmail";
      # mail_sendmailmode = "pipe";
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
      preview_imaginary_url = "http://127.0.0.1:${builtins.toString config.services.imaginary.port}";
      trusted_domains = [
        "${config.services.nextcloud.hostName}"
        "100.125.37.13"
        "192.128.1.61"
        "cwystaws-raspi"
      ];
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
      "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
    };

    notify_push.enable = true;
    enableImagemagick = true;
    configureRedis = true;
    database.createLocally = true;
    maxUploadSize = "4G";
  };
  # services.imaginary = {
  #   enable = true;
  #   settings = {
  #     return-size = true;
  #   };
  # };
  services.collabora-online = {
    enable = true;
    port = 9980; # default
    settings = {
      # Rely on reverse proxy for SSL
      ssl = {
        enable = false;
        termination = true;
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
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
    virtualHosts.${config.services.collabora-online.settings.server_name} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
        proxyWebsockets = true; # collabora uses websockets
      };
    };
  };

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";

  # collabora setup; https://diogotc.com/blog/collabora-nextcloud-nixos/
  systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url = "http://[::1]:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://collabora.example.com";
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
}
