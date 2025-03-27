{pkgs, ...} @ inputs: {
  home.username = "itscrystalline";
  home.homeDirectory = "/home/itscrystalline";

  imports = [
    ./modules/cli.nix
    ./modules/dev.nix
    ./modules/theme.nix
    ./modules/nextcloud.nix
    ./modules/ags.nix
    ./modules/gui.nix
    ./modules/games.nix
    ./modules/flatpak.nix
    ./modules/virtualisation.nix
    ./modules/services.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
