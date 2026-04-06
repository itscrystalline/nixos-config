nixos: {
  config,
  lib,
  ...
}: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = lib.optional nixos "/etc/ssh/ssh_host_ed25519_key";
    age.keyFile =
      if (config ? home)
      then "${config.home.homeDirectory}/.config/sops/age/keys.txt"
      else null;

    secrets =
      (
        if nixos
        then {
          "crystal-password" = {
            neededForUsers = true;
          };

          "homeassistant-wifi-password" = {};
          "homeassistant-token" = {};
          "homeassistant-secrets.yaml" = {};

          "nextcloud-admin-password" = {};
          "nextcloud-admin-stats-token" = {};

          "mail-password" = {};

          "cloudflared-credentials" = {};

          "wifi-passwords" = {};

          "tailscaleAuthKey" = {};

          "harmonia-secret-key" = {};

          "forgejo-admin-password" = {};
          "forgejo-runner-token" = {};

          "stalwart-admin-password" = {};
          "stalwart-real-password" = {};
          "stalwart-itscrystalline-password" = {};
          "stalwart-nc-password" = {};
          "stalwart-git-password" = {};
          "stalwart-cloudflare-token" = {};

          "stalwart-smtp-username" = {};
          "stalwart-smtp-password" = {};
        }
        else {
          "nextcloud-rclone-password" = {};
          "oc-api-keys" = {};
        }
      )
      // {
        "gh-token" = {};
      };
  };
}
