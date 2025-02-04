{ config, pkgs, lib, ... }@inputs:
lib.mkIf config.gui {
  home.packages = with pkgs; [
    (ags.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [
        pkgs.libdbusmenu-gtk3
       	pkgs.libnotify
       	pkgs.gtkmm3
       	pkgs.sassc
       	pkgs.pywal
       	pkgs.webkitgtk
       	pkgs.ydotool
       	pkgs.webp-pixbuf-loader
        pkgs.cairomm
       	pkgs.gtksourceview
       	pkgs.gtksourceview4
       	pkgs.python311Packages.material-color-utilities
        pkgs.python311Packages.pywayland
        pkgs.python311Packages.materialyoucolor
      ];
    }))
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

    # shell script deps
    socat
  ];

  # restart on monitor connect
  home.file.".scripts/monitorconnect.sh".source = pkgs.writeShellScript "monitorconnect.sh" ''
    handle() {
        case $1 in
        monitoradded*) killall .ags-wrapped ydotool; ags & ;;
        monitorremoved*) killall .ags-wrapped ydotool; ags & ;;
        esac
    }

    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
  '';
}
