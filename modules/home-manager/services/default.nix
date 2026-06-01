{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./mpris.nix
    ./nextcloud.nix
  ];
  sops.secrets = {
    "gpg_public" = {};
    "gpg_private" = {};
  };

  home = {
    # Import GPG private keys from sops after public keys are in place.
    # Ordered after linkGeneration because Home Manager's importGpgKeys
    # (which handles publicKeys when mutableKeys = true) runs after linkGeneration.
    # See GnuPG.md Section 8 for the full technical rationale.
    activation.importGpgPrivateKeys = lib.hm.dag.entryAfter ["linkGeneration"] ''
      ${pkgs.gnupg}/bin/gpg --batch --yes --pinentry-mode loopback --allow-secret-key-import --import "${config.sops.secrets.gpg_private.path}" 2>/dev/null || true
    '';
  };
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = config.sops.secrets.gpg_public.path;
        trust = "ultimate";
      }
    ];
  };
  services.gpg-agent = lib.mkMerge [
    {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = lib.mkDefault pkgs.pinentry-tty;
    }
    (lib.mkIf config.hm.gui.enable {
      pinentry.package = pkgs.pinentry-gnome3;
    })
  ];
}
