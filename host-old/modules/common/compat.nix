{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.crystal.compat;
in {
  options.crystal.compat.enable = lib.mkEnableOption "compatibility settings" // {default = true;};

  config = lib.mkIf cfg.enable {
    # steam-run and xhost (add and delete host names or user names to the list allowed to make connections to the X server)
    environment.systemPackages = [pkgs.steam-run pkgs.xorg.xhost];
    # nix-ld
    # NOTE: This library list adds ~50-150 transitive packages. Audit
    # periodically to remove entries no longer needed.
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs;
        [
          (runCommand "steamrun-lib" {} "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib")
          zlib
          libz
          zstd
          stdenv.cc.cc
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd

          # My own additions
          libelf

          # Required

          # Inspired by steam
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
          networkmanager
          coreutils
          pciutils
          # glibc_multi.bin # Seems to cause issue in ARM

          # # Without these it silently fails
          nspr
          nss
          cups
          libcap
          libusb1
          dbus-glib
          ffmpeg
          # Only libraries are needed from those two
          libudev0-shim

          # Other things from runtime
          flac
          libadwaita
          libimobiledevice
          libplist
        ]
        ++ pkgs.lib.optionals config.gui [
          xorg.libXcomposite
          xorg.libXtst
          xorg.libXrandr
          xorg.libXext
          xorg.libX11
          xorg.libXfixes
          libGL
          libva
          pipewire
          xorg.libxcb
          xorg.libXdamage
          xorg.libxshmfence
          xorg.libXxf86vm

          glib
          gtk2

          vulkan-loader
          libgbm
          libdrm
          libxcrypt
          zenity

          xorg.libXinerama
          xorg.libXcursor
          xorg.libXrender
          xorg.libXScrnSaver
          xorg.libXi
          xorg.libSM
          xorg.libICE
          gnome2.GConf
          SDL2

          # needed to run unity
          gtk3
          icu
          libnotify
          gsettings-desktop-schemas
          xorg.libXt
          xorg.libXmu
          libogg
          libvorbis
          SDL
          SDL2_image
          glew110
          libidn
          tbb
          # libsForQt5.full

          SDL_image
          SDL_ttf
          SDL_mixer
          SDL2_ttf
          SDL2_mixer
          libappindicator-gtk2
          libdbusmenu-gtk2
          libindicator-gtk2

          freeglut
          libjpeg
          libpng
          libpng12
          libsamplerate
          libmikmod
          libtheora
          libtiff
          pixman
          speex
          libcaca
          libcanberra
          libgcrypt
          libvpx
          librsvg
          xorg.libXft
          libvdpau
          # ...
          # Some more libraries that I needed to run programs
          pango
          cairo
          atk
          gdk-pixbuf
          fontconfig
          freetype
          dbus
          alsa-lib
          expat
          # For blender
          libxkbcommon
          # For natron
          libxcrypt-legacy
          libGLU
        ];
    };
  };
}
