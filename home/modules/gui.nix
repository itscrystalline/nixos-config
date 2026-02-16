{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crystal.hm.gui;
in {
  imports = [
    ./gui/blender.nix
  ];

  options.crystal.hm.gui.enable = lib.mkEnableOption "GUI applications";
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf config.gui (
      with pkgs.stable;
        [
          vesktop # discor
          beeper # others
          keepassxc
          vlc

          # video, audio, and image editing
          kdePackages.kdenlive # NOTE: pulls in KDE/Qt framework (~200-300 pkgs)
          gimp
          # FUCK YOU WHY ARE YOU SO BIG !!!!! I HAT EYOU!!!!
          # davinci-resolve
          audacity
          # aseprite
          blockbench
          libreoffice # NOTE: pulls in ~150-250 packages (Java, fonts, format libs)

          logisim-evolution
          wireshark

          # fonts (NOTE: also declared in host/modules/common/theming.nix — consider deduplicating)
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          inter
          nerd-fonts.jetbrains-mono
          pkgs.unstable.material-symbols
          sarabun-font
          inputs.my-nur.packages.${pkgs.hostsys}.sipa-th-fonts
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          youtube-music
        ]
    );
    programs = lib.mkIf config.gui {
      # NOTE: Chromium adds ~200-300 packages. It's only used for the LINE
      # webapp extension. If LINE can run in Zen Browser, removing Chromium
      # would significantly reduce the closure.
      chromium = {
        enable = true;
        extensions = [
          "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
        ];
      };

      obs-studio = {
        enable = true;
        plugins = with pkgs.stable.obs-studio-plugins; [
          obs-composite-blur
          # obs-backgroundremoval
          droidcam-obs
        ];
      };

      kitty = {
        enable = true;
        shellIntegration = {
          enableZshIntegration = true;
        };
      };

      fuzzel.enable = true;

      ghostty = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          font-size = 12;
          clipboard-paste-protection = false;
          clipboard-trim-trailing-spaces = true;
        };
        systemd.enable = true;
      };
    };
  };
}
