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

    secrets."gh-token" = {};
    templates."nix-extra-config".content = ''
      access-tokens = github.com=${config.sops.placeholder."gh-token"}
    '';
  };
}
