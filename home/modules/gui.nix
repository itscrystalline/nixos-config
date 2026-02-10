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

  options.crystal.hm.gui.enable = lib.mkEnableOption "GUI applications" // {default = true;};
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf config.gui (
      with pkgs.stable;
        [
          vesktop # discor
          beeper # others
          keepassxc
          vlc

          # video, audio, and image editing
          kdePackages.kdenlive
          gimp
          # FUCK YOU WHY ARE YOU SO BIG !!!!! I HAT EYOU!!!!
          # davinci-resolve
          audacity
          # aseprite
          blockbench
          libreoffice

          logisim-evolution
          wireshark

          # fonts
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
        settings.font-size = 12;
      };
    };
  };
}
