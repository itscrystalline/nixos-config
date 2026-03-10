{
  lib,
  config,
  pkgs,
  inputs ? {},
  passthrough,
  ...
}: let
  inherit (config.hm.programs) cli;
  inherit (cli) fastfetch;
  inherit (lib) types;
  enabled = cli.enable;
in {
  options.hm.programs.cli = {
    enable = lib.mkEnableOption "CLI tools";
    fastfetch.profile = lib.mkOption {
      type = types.enum ["full" "minimal"];
      description = "How much info fastfetch should produce.";
      default = "minimal";
    };
  };

  config = lib.mkIf enabled {
    home.packages = with pkgs;
      [
        blahaj
        zoxide
        sshfs
        nh
        git-crypt
        nix-output-monitor
        tmux
        byobu

        adwaita-icon-theme
        axel
        bc
        cmake
        meson
        tinyxml-2
        libnotify
        jq
        lsof
        qrtool
        socat
        unstable.jocalsend
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        cliphist
        fuzzel
        brightnessctl
        ddcutil
        swww
        mpvpaper
        sass
        sassc
        cava
        yad
        pywal
        swappy
        playerctl
        ydotool
        valent
      ]
      ++ lib.optionals (inputs ? occasion) [
        inputs.occasion.packages.${pkgs.hostsys}.occasion
      ];

    home.shellAliases = {
      svim = "sudo nvim";
      editnix = "cd ~/nixos-config; nvim";
      update =
        if passthrough == null # standalone home-manager
        then "nh home switch ~/nixos-config"
        else "nh os switch ~/nixos-config";
      nuke-cache = "rm -rf ~/.cache/nix";
      gc = "nh clean all";
      clean-hmbkups = "find ${config.home.homeDirectory}/.config -name \"*.hmbkup\" -type f -delete";
      gssh = "TERM=xterm-256color ssh";
      ":q" = "exit";
      lg = "lazygit";
      ls = "eza";
      cat = "bat --paging=never";
      cm = "sudo loadkeys colemak";
      qw = "sudo loadkeys us";
      cargo = "cargo mommy";
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;
        history.append = true;
        initContent = lib.mkBefore ''
          export _ZO_EXCLUDE_DIRS=$HOME:$HOME/Nextcloud/*:/mnt/nfs
          hyfetch
        '';
      };

      bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        sessionVariables."_ZO_EXCLUDE_DIRS" = "$HOME:$HOME/Nextcloud/*:/mnt/nfs";
        initExtra = "hyfetch";
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        options = ["--cmd cd"];
      };

      fastfetch = {
        enable = true;
        settings = {
          display.separator = " : ";
          modules = let
            mkModules = includeOptional: modules:
              map (conf:
                if (builtins.isAttrs conf)
                then (builtins.removeAttrs conf ["optional"])
                else conf)
              (builtins.filter
                (conf:
                  if (builtins.isAttrs conf)
                  then (({optional ? false, ...}: !optional || includeOptional) conf)
                  else true)
                modules);
          in
            mkModules (fastfetch.profile == "full") [
              {
                type = "custom";
                format = "┌──────────────────────────────────────────┐";
                optional = true;
              }
              {
                type = "os";
                key = "   OS";
                keyColor = "red";
              }
              {
                type = "kernel";
                key = "   Kernel";
                keyColor = "red";
              }
              {
                type = "display";
                key = "   Display";
                keyColor = "green";
              }
              {
                type = "wm";
                key = "   WM";
                keyColor = "yellow";
                optional = true;
              }
              {
                type = "terminal";
                key = "   Terminal";
                keyColor = "yellow";
              }
              {
                type = "custom";
                format = "└──────────────────────────────────────────┘";
                optional = true;
              }
              "break"
              {
                type = "title";
                key = "  ";
              }
              {
                type = "custom";
                format = "┌──────────────────────────────────────────┐";
                optional = true;
              }
              {
                type = "cpu";
                format = "{1}";
                key = "   CPU";
                keyColor = "blue";
              }
              {
                type = "gpu";
                format = "{2}";
                key = "   GPU";
                keyColor = "blue";
              }
              {
                type = "gpu";
                format = "{3}";
                key = "   GPU Driver";
                keyColor = "magenta";
              }
              {
                type = "memory";
                key = "  ﬙ Memory";
                keyColor = "magenta";
              }
              {
                type = "command";
                key = "  󱦟 OS Age ";
                keyColor = "31";
                text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
                optional = true;
              }
              {
                type = "uptime";
                key = "  󱫐 Uptime ";
                keyColor = "red";
              }
              {
                type = "custom";
                format = "└──────────────────────────────────────────┘";
                optional = true;
              }
              {
                type = "colors";
                paddingLeft = 2;
                symbol = "circle";
              }
              "break"
            ];
        };
      };

      hyfetch = {
        package = pkgs.unstable.hyfetch;
        enable = true;
        settings = {
          preset = "transbian";
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

      starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = pkgs.lib.importTOML ./starship.toml;
      };

      btop = {
        enable = true;
        settings.update_ms = 200;
      };

      yt-dlp = {
        enable = true;
        package = pkgs.unstable.yt-dlp;
      };

      occasion = lib.mkIf (inputs ? occasion) {
        enable = true;
        package = inputs.occasion.packages.${pkgs.hostsys}.occasion;
        settings = {
          dates = [
            {
              message = "🏳️‍⚧️";
              condition.predicate = "(MONTH == 3 && DAY_OF_MONTH == 31) || (MONTH == 11 && DAY_OF_MONTH == 20)";
            }
            {
              message = "🏳️‍🌈";
              time.month = ["June"];
            }
            {
              message = "❤️🧡🤍🩷💜";
              time = {
                day_of.month = [9 21 22 23 24 25 26 27];
                month = ["April"];
              };
            }
            {
              message = "❤️🧡🤍🩷💜";
              time = {
                day_of.month = [8];
                month = ["October"];
              };
            }
            {
              message = "🖤🩶🤍💜";
              time = {
                day_of.month = [4];
                month = ["April"];
              };
            }
            {
              message = "🖤🩶🤍💜";
              time.month = ["October"];
              condition.predicate = "DAY_OF_MONTH + 6 + (6 - DAY_IN_WEEK) == 31";
              merge_strategy = "AND";
            }
            {
              message = "👨";
              time = {
                day_of.month = [13];
                month = ["September"];
              };
            }
            {
              message = "👩";
              time = {
                day_of.month = [10];
                month = ["October"];
              };
            }
            {
              message = "🧒";
              time = {
                day_of.month = [22];
                month = ["May"];
              };
            }
            {
              message = "🎂";
              time = {
                day_of.month = [4];
                month = ["June"];
              };
            }
            {
              message = "🔄";
              time.day_of.month = [1];
            }
          ];
          multiple_behavior.all.seperator = " ";
        };
      };

      lazygit.enable = true;

      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      bat.enable = true;

      eza = {
        enable = true;
        colors = "always";
        enableZshIntegration = true;
        enableBashIntegration = true;
        icons = "auto";
        git = true;
      };

      zellij = {
        enable = true;
        attachExistingSession = true;
        exitShellOnExit = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings.keybinds = {
          _children = [{unbind._args = ["Ctrl s"];}];
          scroll._children = [
            {
              bind = {
                _args = ["Ctrl /"];
                _children = [{SwitchToMode._args = ["Normal"];}];
              };
            }
          ];
          search._children = [
            {
              bind = {
                _args = ["Ctrl /"];
                _children = [{SwitchToMode._args = ["Normal"];}];
              };
            }
          ];
          session._children = [
            {
              bind = {
                _args = ["Ctrl /"];
                _children = [{SwitchToMode._args = ["Scroll"];}];
              };
            }
          ];
          shared_except = {
            _args = ["scroll" "locked"];
            _children = [
              {
                bind = {
                  _args = ["Ctrl /"];
                  _children = [{SwitchToMode._args = ["Scroll"];}];
                };
              }
            ];
          };
        };
      };

      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
      };
    };
  };
}
