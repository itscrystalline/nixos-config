{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  inherit (config.crystals-services) copyparty;
  enabled = copyparty.enable;

  volumeFlags = {
    # "fk" enables filekeys (necessary for upget permission) (4 chars long)
    fk = 4;
    # scan for new files every 60sec
    scan = 60;
    # volflag "e2d" enables the uploads database
    e2d = true;
  };
  mkVolumes = vols:
    builtins.mapAttrs (_: opts: {
      inherit (opts) path;
      access = {
        r = opts.read;
        rw = opts.read-write;
      };
      flags = volumeFlags;
    })
    vols;
in {
  options.crystals-services.copyparty = {
    enable = mkEnableOption "copyparty";
    volumes = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          path = mkOption {
            type = types.str;
            default = "";
            description = "Host path for this volume.";
          };
          read = mkOption {
            type = types.coercedTo types.str (x: lib.singleton x) (types.listOf types.str);
            default = "*";
            description = "Users that can access this volume read only.";
          };
          read-write = mkOption {
            type = types.coercedTo types.str (x: lib.singleton x) (types.listOf types.str);
            default = [];
            description = "Users that can access and modify this volume.";
          };
        };
      });
      default = {};
      description = "Volumes to enable in copyparty.";
    };
  };
  config = lib.mkIf enabled {
    nixpkgs.overlays = [inputs.copyparty.overlays.default];

    sops.secrets."itscrystalline-copyparty-password".owner = "copyparty";

    services.copyparty = {
      enable = true;
      package = pkgs.copyparty.override {
        withFastThumbnails = true;
        withMagic = true;

        extraPackages = [pkgs.exiftool pkgs.cfssl];
      };
      # the user to run the service as
      user = "copyparty";
      # the group to run the service as
      group = "copyparty";
      settings = {
        # directly maps to values in the [global] section of the copyparty config.
        # see `copyparty --help` for available options
        i = "unix:770:/run/copyparty/copyparty.sock";
        xff-hdr = "cf-connecting-ip";
        xf-proto = "https";
        xf-host = "x-forwarded-host";
        xff-src = "lan";
        rproxy = 1;
      };

      accounts.itscrystalline.passwordFile = config.sops.secrets.itscrystalline-copyparty-password.path;

      volumes = mkVolumes copyparty.volumes;
      openFilesLimit = 8192;
    };
    crystals-services.nginx.public.sites."static" = {
      locations."/" = {
        proxyPass = "http://copyparty";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect off;
          proxy_buffering off;
          proxy_request_buffering off;
          proxy_buffers 32 8k;
          proxy_buffer_size 16k;
          proxy_busy_buffers_size 24k;
          proxy_set_header Connection "Keep-Alive";
          proxy_set_header Origin "http://static.iw2tryhard.dev";
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
      acme = "";
      acmeReloadedService = "copyparty.service";
      acmeUser = "copyparty";
    };
    services.nginx = {
      upstreams.copyparty.servers."unix:/run/copyparty/copyparty.sock" = {};
    };
    crystals-services.cloudflared.domains."static" = {
      disableChunkedEncoding = true;
      noHappyEyeballs = true;
    };
    users.groups.copyparty.members = [config.services.copyparty.user config.services.nginx.user];
    systemd.tmpfiles.rules = ["d /run/copyparty 0750 copyparty copyparty -"];
  };
}
