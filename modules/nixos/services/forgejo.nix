{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  inherit (config.crystals-services) forgejo;
  enabled = forgejo.enable;

  cfg = config.services.forgejo;
  srv = cfg.settings.server;
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    hash = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };
  theme-name = "catppuccin-mocha-pink";

  DOMAIN = "git.iw2tryhard.dev";
  ROOT_URL = "https://${DOMAIN}/";
in {
  options.crystals-services.forgejo = {
    enable = mkEnableOption "forgejo server";
    runner.enable = mkEnableOption "forgejo actions runner";
    directory = mkOption {
      type = types.str;
      description = "Forgejo's state directory.";
      default = "/var/lib/forgejo";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf enabled {
      crystals-services.cloudflared.domains."git".noTLSVerify = true;

      sops.secrets.forgejo-admin-password.owner = "forgejo";
      systemd.services.forgejo.preStart = let
        adminCmd = "${lib.getExe cfg.package} admin user";
        pwd = config.sops.secrets.forgejo-admin-password;
        user = "itscrystalline"; # Note, Forgejo doesn't allow creation of an account named "admin"
      in ''
        ${adminCmd} create --admin --email "real@iw2tryhard.dev" --username ${user} --password "$(< ${pwd.path})" || true
        # ${adminCmd} change-password --username ${user} --password "$(< ${pwd.path})" || true
      '';

      systemd.tmpfiles.rules = [
        "d '${config.services.forgejo.customDir}/public' - forgejo forgejo - -"
        "d '${config.services.forgejo.customDir}/public/assets' - forgejo forgejo - -"
        "d '${config.services.forgejo.customDir}/public/assets/css' - forgejo forgejo - -"
        "C+ '${config.services.forgejo.customDir}/public/assets/css/theme-${theme-name}.css' - forgejo forgejo - ${theme}/theme-${theme-name}.css"
      ];

      services = {
        forgejo = {
          enable = true;
          database.type = "sqlite3";
          stateDir = forgejo.directory;
          lfs.enable = true;
          settings = {
            server = {
              inherit DOMAIN ROOT_URL;
              HTTP_PORT = 4985;
              SSH_PORT = lib.head config.services.openssh.ports;
            };
            # You can temporarily allow registration to create an admin user.
            service.DISABLE_REGISTRATION = true;
            # Add support for actions, based on act: https://github.com/nektos/act
            actions = {
              ENABLED = true;
              DEFAULT_ACTIONS_URL = "github";
            };
            ui = {
              THEMES = theme-name;
              DEFAULT_THEME = theme-name;
            };

            mailer = {
              ENABLED = true;
              PROTOCOL = "smtps";
              SMTP_ADDR = "smtp.gmail.com";
              SMTP_PORT = 465;
              FROM = "git@iw2tryhard.dev";
              USER = "choyrumthad@gmail.com";
            };
          };
          secrets = {
            mailer.PASSWD = config.sops.secrets.mail-password.path;
          };
        };

        nginx.virtualHosts.${srv.DOMAIN} = {
          extraConfig = ''
            client_max_body_size 512M;
          '';
          locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
        };
      };
    })
    (lib.mkIf forgejo.runner.enable {
      services.gitea-actions-runner = {
        package = pkgs.forgejo-runner;
        instances.default = {
          enable = true;
          name = "monolith";
          url = ROOT_URL;
          # Obtaining the path to the runner token file may differ
          # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
          tokenFile = config.sops.secrets.forgejo-runner-token.path;
          labels = [
            "ubuntu-latest:docker://node:16-bullseye"
            "ubuntu-22.04:docker://node:16-bullseye"
            "ubuntu-20.04:docker://node:16-bullseye"
            "ubuntu-18.04:docker://node:16-buster"
            ## optionally provide native execution on the host:
            "native:host"
          ];
        };
      };
    })
  ];
}
