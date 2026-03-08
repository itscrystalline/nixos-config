# NixOS sops-nix module for runtime secrets.
# These secrets are decrypted at activation time into /run/secrets/ and
# are NOT embedded in the Nix store, unlike the build-time git-crypt secrets
# in secrets.nix which are used directly as Nix values.
#
# Age key used for decryption is derived from the host's SSH ed25519 host key.
# See .sops.yaml for key configuration.
nixos: _: {
  sops = {
    defaultSopsFile = ./secrets-runtime.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets =
      if nixos
      then {
        # Hashed user password – kept out of the Nix store via hashedPasswordFile.
        "crystal-password" = {
          neededForUsers = true;
        };

        # WiFi hotspot passphrase for create_ap – injected at service startup.
        "homeassistant-wifi-password" = {};

        # Nextcloud admin password – passed as a file path to the nextcloud module.
        # Owner set to "nextcloud" by the nextcloud service module when enabled.
        "nextcloud-admin-password" = {};

        # Nextcloud serverinfo stats API token – used as a file path.
        # Owner set to "nextcloud" by the nextcloud service module when enabled.
        "nextcloud-admin-stats-token" = {};

        # Mail account password – read at send-time via msmtp passwordeval.
        "mail-password" = {};

        # Cloudflare tunnel credentials JSON – used as credentialsFile.
        # systemd LoadCredential reads this as root; no owner override needed.
        "cloudflared-credentials" = {};

        # Shell environment file with WiFi PSK variables for NM ensureProfiles.
        # Format: VAR_NAME=psk-value (one per line).
        # Profile entries in known-networks reference these as $VAR_NAME.
        "wifi-passwords" = {};
      }
      else {
        "oc-api-keys" = {};
      };
  };
}
