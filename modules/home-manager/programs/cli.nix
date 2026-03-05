{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  inherit (config.hm.programs) cli;
  inherit (cli) fastfetch;
  inherit (lib) types;
  enabled = cli.enable;
in {
  options.hm.programs.cli = {
    enable = lib.mkEnableOption "CLI tools" // {default = true;};
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
      update = "nh os switch ~/nixos-config";
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

      fish.enable = true;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        options = ["--cmd cd"];
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
          "cwystaws-raspi" = {
            hostname = "cwystaws-raspi";
            identityFile = "${config.home.homeDirectory}/.ssh/crystal";
          };
          "cwystaws-dormpi" = {
            hostname = "cwystaws-dormpi";
            identityFile = "${config.home.homeDirectory}/.ssh/dormpi";
          };
        };
      };

      fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = ''$(find "''${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/pngs/" -name "*.png" | shuf -n 1)'';
            height = 18;
          };
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
                format = "\\u001b[36m    コンピューター";
              }
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
        theme = lib.optionalAttrs config.hm.theming.enable {
          colourful = true;
          filekinds = {
            normal = {foreground = "#BAC2DE";};
            directory = {foreground = "#89B4FA";};
            symlink = {foreground = "#89DCEB";};
            pipe = {foreground = "#7F849C";};
            block_device = {foreground = "#EBA0AC";};
            char_device = {foreground = "#EBA0AC";};
            socket = {foreground = "#585B70";};
            special = {foreground = "#CBA6F7";};
            executable = {foreground = "#A6E3A1";};
            mount_point = {foreground = "#74C7EC";};
          };
          perms = {
            user_read = {foreground = "#CDD6F4";};
            user_write = {foreground = "#F9E2AF";};
            user_execute_file = {foreground = "#A6E3A1";};
            user_execute_other = {foreground = "#A6E3A1";};
            group_read = {foreground = "#BAC2DE";};
            group_write = {foreground = "#F9E2AF";};
            group_execute = {foreground = "#A6E3A1";};
            other_read = {foreground = "#A6ADC8";};
            other_write = {foreground = "#F9E2AF";};
            other_execute = {foreground = "#A6E3A1";};
            special_user_file = {foreground = "#CBA6F7";};
            special_other = {foreground = "#585B70";};
            attribute = {foreground = "#A6ADC8";};
          };
          size = {
            major = {foreground = "#A6ADC8";};
            minor = {foreground = "#89DCEB";};
            number_byte = {foreground = "#CDD6F4";};
            number_kilo = {foreground = "#BAC2DE";};
            number_mega = {foreground = "#89B4FA";};
            number_giga = {foreground = "#CBA6F7";};
            number_huge = {foreground = "#CBA6F7";};
            unit_byte = {foreground = "#A6ADC8";};
            unit_kilo = {foreground = "#89B4FA";};
            unit_mega = {foreground = "#CBA6F7";};
            unit_giga = {foreground = "#CBA6F7";};
            unit_huge = {foreground = "#74C7EC";};
          };
          users = {
            user_you = {foreground = "#CDD6F4";};
            user_root = {foreground = "#F38BA8";};
            user_other = {foreground = "#CBA6F7";};
            group_yours = {foreground = "#BAC2DE";};
            group_other = {foreground = "#7F849C";};
            group_root = {foreground = "#F38BA8";};
          };
          links = {
            normal = {foreground = "#89DCEB";};
            multi_link_file = {foreground = "#74C7EC";};
          };
          git = {
            new = {foreground = "#A6E3A1";};
            modified = {foreground = "#F9E2AF";};
            deleted = {foreground = "#F38BA8";};
            renamed = {foreground = "#94E2D5";};
            typechange = {foreground = "#F5C2E7";};
            ignored = {foreground = "#7F849C";};
            conflicted = {foreground = "#EBA0AC";};
          };
          git_repo = {
            branch_main = {foreground = "#CDD6F4";};
            branch_other = {foreground = "#CBA6F7";};
            git_clean = {foreground = "#A6E3A1";};
            git_dirty = {foreground = "#F38BA8";};
          };
          security_context = {
            colon = {foreground = "#7F849C";};
            user = {foreground = "#BAC2DE";};
            role = {foreground = "#CBA6F7";};
            typ = {foreground = "#585B70";};
            range = {foreground = "#CBA6F7";};
          };
          file_type = {
            image = {foreground = "#F9E2AF";};
            video = {foreground = "#F38BA8";};
            music = {foreground = "#A6E3A1";};
            lossless = {foreground = "#94E2D5";};
            crypto = {foreground = "#585B70";};
            document = {foreground = "#CDD6F4";};
            compressed = {foreground = "#F5C2E7";};
            temp = {foreground = "#EBA0AC";};
            compiled = {foreground = "#74C7EC";};
            build = {foreground = "#585B70";};
            source = {foreground = "#89B4FA";};
          };
          punctuation = {foreground = "#7F849C";};
          date = {foreground = "#F9E2AF";};
          inode = {foreground = "#A6ADC8";};
          blocks = {foreground = "#9399B2";};
          header = {foreground = "#CDD6F4";};
          octal = {foreground = "#94E2D5";};
          flags = {foreground = "#CBA6F7";};
          symlink_path = {foreground = "#89DCEB";};
          control_char = {foreground = "#74C7EC";};
          broken_symlink = {foreground = "#F38BA8";};
          broken_path_overlay = {foreground = "#585B70";};
        };
      };

      zellij = {
        enable = true;
        attachExistingSession = false;
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
