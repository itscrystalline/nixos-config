{ config, pkgs, zen-browser, blender-flake, ... }@inputs:
{
  home.packages = with pkgs; [
    vesktop # discor
    teams-for-linux # teams :vomit:
    (youtube-music.overrideAttrs (finalAttrs: previousAttrs: {
      desktopItems = [
          (makeDesktopItem {
            name = "youtube-music";
            exec = "youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
            icon = "youtube-music";
            desktopName = "Youtube Music";
            startupWMClass = "Youtube Music";
            categories = [ "AudioVideo" ];
          })
        ];
    })) # YT Music
    keepassxc
    teamviewer
    pavucontrol
    vlc

    (blender_4_3.overrideAttrs (oldAttrs: let
      libs = [ wayland libdecor xorg.libX11 xorg.libXi xorg.libXxf86vm xorg.libXfixes xorg.libXrender libxkbcommon
        libGLU libglvnd numactl SDL2 libdrm ocl-icd stdenv.cc.cc.lib openal xorg.libSM xorg.libICE zlib ];
      in {
      installPhase = ''
                    cd $out/libexec
                    mv blender-* blender

                    sed -i 's|^Exec=blender %f|Exec=INTEL_DEBUG=reemit blender %f|' ./blender/blender.desktop

                    mkdir -p $out/share/applications
                    mv ./blender/blender.desktop $out/share/applications/blender.desktop

                    mkdir $out/bin

                    makeWrapper $out/libexec/blender/blender $out/bin/blender \
                      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath libs} \
                      --prefix INTEL_DEBUG : reemit

                    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                      blender/blender

                    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  \
                      $out/libexec/blender/*/python/bin/python3*
                  '';
    }))
  ] ++ [
    zen-browser.packages.${pkgs.system}.default
  ];
}
