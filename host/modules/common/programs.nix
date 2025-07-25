{
  config,
  pkgs,
  ...
} @ inputs: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep ${builtins.toString config.keep_generations}";
  };

  programs.zsh.enable = true;
  programs.bash = {
    completion.enable = true;
    enableLsColors = true;
    vteIntegration = true;
  };
  # ZSH system completion
  environment.pathsToLink = ["/share/zsh" "/share/nautilus-python/extensions"];

  # git config
  programs.git = {
    config = {
      safe = {
        directory = "/home/itscrystalline/nixos-config";
      };
    };
  };
  programs.dconf.enable = true;

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
    tree
    hydra-check

    htop
    btop
    powertop

    lsof
    tmux

    linuxKernel.packages.linux_6_12.usbip

    lm_sensors
  ];
  # powerManagement.powertop.enable = true;
}
