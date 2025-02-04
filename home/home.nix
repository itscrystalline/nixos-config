{ config, pkgs, nur, catppuccin, zen-browser, nix-jebrains-plugins, nix-flatpak, ... }@inputs:

{
  home.username = "itscrystalline";
  home.homeDirectory = "/home/itscrystalline"; 

  imports = [
    ./config.nix
    ./modules/cli.nix
    ./modules/dev.nix
    ./modules/theme.nix
    ./modules/nextcloud.nix
  ] ++ pkgs.lib.optionals config.gui [
    ./modules/ags.nix
    ./modules/gui.nix
    ./modules/games.nix
    ./modules/flatpak.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

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

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };


  # MPRIS Proxy (Bluetooth Audio)
  services.mpris-proxy.enable = true;

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
