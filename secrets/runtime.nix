# NixOS sops-nix module for runtime secrets.
# These secrets are decrypted at activation time into /run/secrets/ and
# are NOT embedded in the Nix store, unlike the build-time git-crypt secrets
# in secrets.nix which are used directly as Nix values.
#
# Age key used for decryption is derived from the host's SSH ed25519 host key.
# See .sops.yaml for key configuration.
{...}: {
  sops = {
    defaultSopsFile = ./secrets-runtime.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      # Hashed user password – kept out of the Nix store via hashedPasswordFile.
      crystal_password = {
        neededForUsers = true;
      };

      # WiFi hotspot passphrase for create_ap – injected at service startup.
      homeassistant_wifi_password = {};

      # Nextcloud admin password – passed as a file path to the nextcloud module.
      # Owner set to "nextcloud" by the nextcloud service module when enabled.
      nextcloud_admin_password = {};

      # Nextcloud serverinfo stats API token – used as a file path.
      # Owner set to "nextcloud" by the nextcloud service module when enabled.
      nextcloud_admin_stats_token = {};

      # Mail account password – read at send-time via msmtp passwordeval.
      mail_password = {};

      # Cloudflare tunnel credentials JSON – used as credentialsFile.
      # Owner set to "cloudflared" by the cloudflared service module when enabled.
      cloudflared_credentials = {};
    };
  };
}
