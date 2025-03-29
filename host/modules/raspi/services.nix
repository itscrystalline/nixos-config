{
  config,
  inputs,
  pkgs,
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
    pass = builtins.toPath ../../../secrets/nc_password.txt;
  in {
    enable = true;
    package = pkgs.nextcloud30;
    home = "/mnt/main/nextcloud";
    hostName = "nc.iw2tryhard.dev";
    https = true;
    config = {
      dbtype = "mysql";
      adminpassFile = "${pass}";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit news contacts calendar tasks recognize phonetrack memories previewgenerator notes groupfolders;
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
    };

    notify_push.enable = true;
    enableImagemagick = true;
    configureRedis = true;
    database.createLocally = true;
    maxUploadSize = "4G";
  };
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
