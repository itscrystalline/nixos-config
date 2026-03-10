# NixOS sops-nix module for runtime secrets.
# These secrets are decrypted at activation time into /run/secrets/ and
# are NOT embedded in the Nix store, unlike the build-time git-crypt secrets
# in secrets.nix which are used directly as Nix values.
#
# Age key used for decryption is derived from the host's SSH ed25519 host key.
# See .sops.yaml for key configuration.
nixos: {
  config,
  lib,
  ...
}: {
  sops = {
    defaultSopsFile = ./secrets-runtime.yaml;
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

          "nextcloud-admin-password" = {};
          "nextcloud-admin-stats-token" = {};

          "mail-password" = {};

          "cloudflared-credentials" = {};

          "wifi-passwords" = {};
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
