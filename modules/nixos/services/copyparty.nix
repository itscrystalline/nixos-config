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
      };

      accounts.itscrystalline.passwordFile = config.sops.secrets.itscrystalline-copyparty-password.path;

      volumes = mkVolumes copyparty.volumes;
      openFilesLimit = 8192;
    };
    services.nginx = {
      virtualHosts."static.iw2tryhard.dev" = {
        serverAliases = ["static.${config.crystals-services.nginx.localSuffix}"];
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
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
        extraConfig = ''
          allow 173.245.48.0/20;
          allow 103.21.244.0/22;
          allow 103.22.200.0/22;
          allow 103.31.4.0/22;
          allow 141.101.64.0/18;
          allow 108.162.192.0/18;
          allow 190.93.240.0/20;
          allow 188.114.96.0/20;
          allow 197.234.240.0/22;
          allow 198.41.128.0/17;
          allow 162.158.0.0/15;
          allow 104.16.0.0/13;
          allow 104.24.0.0/14;
          allow 172.64.0.0/13;
          allow 131.0.72.0/222400:cb00::/32;
          allow 2606:4700::/32;
          allow 2803:f800::/32;
          allow 2405:b500::/32;
          allow 2405:8100::/32;
          allow 2a06:98c0::/29;
          allow 2c0f:f248::/32;
          deny all;
        '';
      };
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
