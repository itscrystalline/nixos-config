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
  srv = forgejo.settings.server;
in {
  options.crystals-services.forgejo = {
    enable = mkEnableOption "forgejo server";
  };
  config = lib.mkIf enabled {
    crystals-services.cloudflared.domains."git".noTLSVerify = true;

    sops.secrets.forgejo-admin-password.owner = "forgejo";
    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets.forgejo-admin-password;
      user = "itscrystalline"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in ''
      ${adminCmd} create --admin --email "real@iw2tryhard.dev" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';

    services = {
      forgejo = {
        enable = true;
        database.type = "sqlite3";
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = "git.iw2tryhard.dev";
            ROOT_URL = "https://${srv.DOMAIN}/";
            HTTP_PORT = 3000;
            SSH_PORT = lib.head config.services.openssh.ports;
          };
          # You can temporarily allow registration to create an admin user.
          service.DISABLE_REGISTRATION = true;
          # Add support for actions, based on act: https://github.com/nektos/act
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "github";
          };
          # Sending emails is completely optional
          # You can send a test email from the web UI at:
          # Profile Picture > Site Administration > Configuration >  Mailer Configuration

          # TODO: later noobs
          # mailer = {
          #   ENABLED = true;
          #   SMTP_ADDR = "mail.example.com";
          #   FROM = "noreply@${srv.DOMAIN}";
          #   USER = "noreply@${srv.DOMAIN}";
          # };
        };
        # secrets = {
        #   mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
        # };
      };

      # TODO: enable when forgejo is up
      # gitea-actions-runner = {
      #   package = pkgs.forgejo-runner;
      #   instances.default = {
      #     enable = true;
      #     name = "monolith";
      #     url = srv.ROOT_URL;
      #     # Obtaining the path to the runner token file may differ
      #     # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
      #     tokenFile = config.age.secrets.forgejo-runner-token.path;
      #     labels = [
      #       "ubuntu-latest:docker://node:16-bullseye"
      #       "ubuntu-22.04:docker://node:16-bullseye"
      #       "ubuntu-20.04:docker://node:16-bullseye"
      #       "ubuntu-18.04:docker://node:16-buster"
      #       ## optionally provide native execution on the host:
      #       "native:host"
      #     ];
      #   };
      # };

      nginx.virtualHosts.${srv.DOMAIN} = {
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
      };
    };
  };
}
