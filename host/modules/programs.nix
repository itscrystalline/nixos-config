{ config, pkgs, ... }@inputs:
{
  # Install firefox.
  programs.firefox.enable = true;

  # Install ZSH.
  programs.zsh.enable = true;
  # ZSH system completion
  environment.pathsToLink = [ "/share/zsh" "/share/nautilus-python/extensions" ];
  environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = pkgs.lib.mkForce "${pkgs.gnome.nautilus-python}/lib/nautilus/extensions-4";

  # open any terminal in nautilus
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # git config
  programs.git = {
    config = {
      safe = {
        directory = "/home/itscrystalline/nixos-config";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # (own the) libs
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct

    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    curl
    bind
    rsync
    ripgrep
    gojq
    killall
    rclone
    git
    polkit_gnome
    gnome-keyring
    # open any term
    nautilus-python

    htop
    btop
  ];
}
