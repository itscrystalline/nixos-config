{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  gui = config.gui;
in {
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf gui {
    programs.ags = {
      enable = false;
      extraPackages = with pkgs; [
        libdbusmenu-gtk3
        libnotify
        gtkmm3
        sassc
        pywal
        webkitgtk_4_1
        ydotool
        webp-pixbuf-loader
        cairomm
        gtksourceview
        gtksourceview4
        python311Packages.material-color-utilities
        python311Packages.pywayland
        python311Packages.materialyoucolor
      ];
    };
    home.packages = with pkgs; [
      (python311.withPackages (p: [
        p.material-color-utilities
        p.pywayland
        p.materialyoucolor
      ]))
      adwaita-icon-theme
      axel
      bc
      cliphist
      cmake
      fuzzel
      meson
      tinyxml-2
      brightnessctl
      ddcutil
      swww
      mpvpaper
      sass
      sassc
      libnotify
      cava
      yad
      jq
      pywal
      fuzzel
      lsof
      material-symbols
      swappy
      qrtool
      playerctl
      ydotool

      # shell script deps
      socat
    ];

    # restart on monitor connect
    home.file.".scripts/monitorconnect.sh".source = pkgs.writeShellScript "monitorconnect.sh" ''
      handle() {
          case $1 in
          monitoradded*) killall .ags-wrapped ydotool; swww img /home/itscrystalline/bg.gif --filter=Nearest; ags & ;;
          monitorremoved*) killall .ags-wrapped ydotool; swww img /home/itscrystalline/bg.gif --filter=Nearest; ags & ;;
          esac
      }

      socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
    '';
  };
}
