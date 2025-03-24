{ config, pkgs, ... }@inputs:
{
  programs.zsh.enable = true;
  # ZSH system completion
  environment.pathsToLink = [ "/share/zsh" "/share/nautilus-python/extensions" ];

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
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    bind
    rsync
    ripgrep
    gojq
    killall
    rclone
    git
    file
    fd
    unzip
    hydra-check

    htop
    btop
    powertop

    linuxKernel.packages.linux_6_12.usbip
  ];
  # powerManagement.powertop.enable = true;
}

