{
  config,
  lib,
  pkgs,
  ...
}: let
  enabled = config.programs.enable;
in {
  config = lib.mkIf enabled {
    environment.variables.EDITOR = "nvim";
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        histSize = 100000;
        histFile = "$HOME/.zsh_history";
      };
      bash = {
        completion.enable = true;
        enableLsColors = true;
        vteIntegration = true;
      };
      git = {
        enable = true;
        config.safe.directory = "/home/${config.core.primaryUser}/nixos-config";
      };
    };

    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      bind
      rsync
      ripgrep
      gojq
      killall
      rclone
      file
      fd
      unzip
      tree
      htop
      btop
      powertop
      git-crypt
      lsof
      lm_sensors
      pciutils
      usbutils
      tmux
    ];
  };
}
