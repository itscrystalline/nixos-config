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

  icons = pkgs.stdenvNoCC.mkDerivation {
    name = "forgejo-file-icons";

    src = pkgs.fetchgit {
      url = "https://git.cathedral.gg/Ben/forgejo-file-icons";
      rev = "2b57afb2c2e04984c2f819600c666a048cd53c81";
      hash = "sha256-A0VaCxk8eBITP/PFdlpiidLPuCWiHK+7VWDInoqFHMo=";
    };

    nativeBuildInputs = [pkgs.bash];

    buildPhase = ''
      bash ./build.sh
    '';
    installPhase = ''
      mkdir -p $out
      cp -r icons $out/icons
      cp templates/custom/header.tmpl $out/header.tmpl
    '';
  };

  DOMAIN = "git.iw2tryhard.dev";
  ROOT_URL = "https://${DOMAIN}/";
in {
  options.crystals-services.forgejo = {
    enable = mkEnableOption "forgejo server";
    runner.enable = mkEnableOption "forgejo actions runner";
    sync.enable = mkEnableOption "syncing to github from forgejo. requires importing the forgesync.nixosModules.default module";

    directory = mkOption {
      type = types.str;
      description = "Forgejo's state directory.";
      default = "/var/lib/forgejo";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf enabled {
      crystals-services.cloudflared.domains."git".noTLSVerify = true;

      sops.secrets = {
        "forgejo-admin-password".owner = "forgejo";
        "forgejo-mail-password" = {};
      };

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

        "C+ '${config.services.forgejo.customDir}/public/assets/icons' - forgejo forgejo - ${icons}/icons"

        "d '${config.services.forgejo.customDir}/templates' - forgejo forgejo - -"
        "d '${config.services.forgejo.customDir}/templates/custom' - forgejo forgejo - -"
        "C+ '${config.services.forgejo.customDir}/templates/custom/header.tmpl' - forgejo forgejo - ${icons}/header.tmpl"
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
            service = {
              # You can temporarily allow registration to create an admin user.
              DISABLE_REGISTRATION = true;
              ENABLE_NOTIFY_MAIL = true;
            };
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
              SMTP_ADDR = "mx1.iw2tryhard.dev";
              SMTP_PORT = 465;
              FROM = "git@iw2tryhard.dev";
              USER = "git@iw2tryhard.dev";
            };
          };
          secrets = {
            mailer.PASSWD = config.sops.secrets.forgejo-mail-password.path;
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
      sops.secrets."forgejo-runner-token" = {};

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
            "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:runner-latest"
            "ubuntu-24.04:docker://ghcr.io/catthehacker/ubuntu:runner-24.04"
            "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:runner-22.04"
            "ubuntu-20.04:docker://ghcr.io/catthehacker/ubuntu:runner-20.04"
            "ubuntu-18.04:docker://ghcr.io/catthehacker/ubuntu:runner-18.04"

            "ubuntu-latest-arm:docker://ghcr.io/catthehacker/ubuntu:runner-latest"
            "ubuntu-24.04-arm:docker://ghcr.io/catthehacker/ubuntu:runner-24.04"
            "ubuntu-22.04-arm:docker://ghcr.io/catthehacker/ubuntu:runner-22.04"
            "ubuntu-20.04-arm:docker://ghcr.io/catthehacker/ubuntu:runner-20.04"
            "ubuntu-18.04-arm:docker://ghcr.io/catthehacker/ubuntu:runner-18.04"

            "node:docker://node:16-bullseye"
            "native:host"
          ];
        };
      };
    })
    (lib.mkIf (forgejo.enable && forgejo.sync.enable) {
      sops.secrets."forgejo-sync" = {};

      services.forgesync = {
        enable = true;
        jobs = {
          github = {
            source = "${ROOT_URL}/api/v1";
            target = "github";

            settings = {
              remirror = true;
              feature = [
                "issues"
                "pull-requests"
                "actions"
                "discussions"
                "wiki"
                "releases"
                # "projects"
              ];
              description-template = "{description} (Mirror of {url})";
              on-commit = true;
              mirror-interval = "0h0m0s";
            };

            secretFile = config.sops.secrets.forgejo-sync.path;

            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
        };
      };
    })
  ];
}
