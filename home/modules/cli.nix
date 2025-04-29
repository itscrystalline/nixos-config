{
  config,
  pkgs,
  lib,
  home,
  ...
} @ inputs: {
  home.packages = with pkgs;
    [
      blahaj
      zoxide
      sshfs
      nh
    ]
    ++ lib.optionals config.doas [doas-sudo-shim];

  home.shellAliases = {
    # sudo = "doas";
    svim = "sudo nvim";
    update = "sudo nh os switch ~/nixos-config -R";
    nuke-cache = "sudo rm -rf ~/.cache/nix";
    gc = "sudo nh clean all";
    clean-hmbkups = "find /home/${config.username}/.config -name \"*.hmbkup\" -type f -delete";
    gssh = "TERM=xterm-256color ssh";
    ":q" = "exit";

    # :3
    cargo = "cargo mommy";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    history = {
      append = true;
    };
    initExtraFirst = ''
      export _ZO_EXCLUDE_DIRS=$HOME:$HOME/Nextcloud/*
    '';
    initExtra = ''
      hyfetch
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    sessionVariables."_ZO_EXCLUDE_DIRS" = "$HOME:$HOME/Nextcloud/*";
    initExtra = ''
      hyfetch
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "cwystaws-raspi" = {
        hostname = "cwystaws-raspi";
        identityFile = "/home/${config.username}/.ssh/crystal";
      };
    };
  };

  # fetches
  programs.fastfetch.enable = true;
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transfeminine";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "horizontal";
        custom_colors = [];
        fore_back = [];
      };
      backend = "fastfetch";
      args = null;
      distro = null;
      pride_month_shown = [];
      pride_month_disable = false;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.btop = {
    enable = true;
    settings = {
      update_ms = 200;
    };
  };

  programs.yt-dlp = {
    enable = true;
    package = pkgs.unstable.yt-dlp;
  };

  programs.occasion = {
    enable = true;
    package = inputs.occasion.packages.${pkgs.system}.occasion-latest;
    settings = {
      dates = [
        {
          message = "test";
          time = {
            day_of = {
              week = ["Tuesday"];
            };
          };
        }
      ];
      multiple_behavior = {
        all = {seperator = "";};
      };
    };
  };

  programs.lazygit.enable = true;
}
