{ config, pkgs, catppuccin, zen-browser, nix-jebrains-plugins, ... }@inputs:

{
  imports = [
    ./modules/ags.nix
    ./modules/cli.nix
    ./modules/gui.nix
    ./modules/dev.nix
    ./modules/theme.nix
    ./modules/nextcloud.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "itscrystalline";
  home.homeDirectory = "/home/itscrystalline";

  # gnome polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      After = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
	    Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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
