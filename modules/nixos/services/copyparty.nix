{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  inherit (config.crystals-services) copyparty;
  enabled = copyparty.enable;
in {
  options.crystals-services.copyparty = {
    enable = mkEnableOption "copyparty";
    # directory = mkOption {
    #   type = types.path;
    #   default = "/mnt/main/nfs";
    #   description = "Directory to store stalwart data";
    # };
  };
  config = lib.mkIf enabled {
    nixpkgs.overlays = [copyparty.overlays.default];
    network.ports.tcp = [3210 3211];

    sops.secrets."itscrystalline-copyparty-password".owner = "copyparty";

    services.copyparty = {
      enable = true;
      package = pkgs.copyparty.override {
        withFastThumbnails = true;
        withMagic = true;

        extraPackages = [pkgs.exiftool];
      };
      # the user to run the service as
      user = "copyparty";
      # the group to run the service as
      group = "copyparty";
      # directly maps to values in the [global] section of the copyparty config.
      # see `copyparty --help` for available options
      settings = {
        i = "unix:666:/run/copyparty/copyparty.sock";
      };

      accounts.itscrystalline.passwordFile = config.sops.secrets.itscrystalline-copyparty-password.path;

      # create a volume
      volumes = {
        # create a volume at "/" (the webroot), which will
        "/" = {
          # share the contents of "/srv/copyparty"
          path = "/mnt/main/nfs";
          # see `copyparty --help-accounts` for available options
          access.rw = ["itscrystalline"];
          # see `copyparty --help-flags` for available options
          flags = {
            # "fk" enables filekeys (necessary for upget permission) (4 chars long)
            fk = 4;
            # scan for new files every 60sec
            scan = 60;
            # volflag "e2d" enables the uploads database
            e2d = true;
          };
        };
        "/public" = {
          # share the contents of "/srv/copyparty"
          path = "/mnt/main/nfs/public";
          # see `copyparty --help-accounts` for available options
          access = {
            # everyone gets read-access, but
            r = "*";
            # users "ed" and "k" get read-write
            rw = ["itscrystalline"];
          };
          # see `copyparty --help-flags` for available options
          flags = {
            # "fk" enables filekeys (necessary for upget permission) (4 chars long)
            fk = 4;
            # scan for new files every 60sec
            scan = 60;
            # volflag "e2d" enables the uploads database
            e2d = true;
          };
        };
      };
      openFilesLimit = 8192;
    };
    services.nginx = {
      virtualHosts."static.iw2tryhard.dev".locations."/" = {
        serverAliases = ["static.${config.crystals-services.nginx.localSuffix}"];
        proxyPass = "http://copyparty";
        proxyWebsockets = true;
      };
      upstreams.copyparty.servers."unix:/run/copyparty/copyparty.sock" = {};
    };
  };
}
