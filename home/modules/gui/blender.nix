{ pkgs, ... }:
let
  blenderkit_version = "3.13.0.241112";
in {
  home.packages = with pkgs; [
    (blender_4_3.overrideAttrs (oldAttrs: newAttrs: let
          libs = [ wayland libdecor xorg.libX11 xorg.libXi xorg.libXxf86vm xorg.libXfixes xorg.libXrender libxkbcommon
            libGLU libglvnd numactl SDL2 libdrm ocl-icd stdenv.cc.cc.lib openal xorg.libSM xorg.libICE zlib ];
          in {
          installPhase = ''
                        cd $out/libexec
                        mv blender-* blender

                        sed -i 's|^Exec=blender %f|Exec=env INTEL_DEBUG=reemit blender %f|' ./blender/blender.desktop

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
  ];

  # Add-ons
  xdg.configFile."blender/4.3/extensions/user_default".source = pkgs.fetchzip {
    name = "blenderkit";
    url = "https://github.com/BlenderKit/BlenderKit/releases/download/v${blenderkit_version}/blenderkit-v${blenderkit_version}.zip";
    sha256 = "sha256-nKafsyrMKVQzgvbiurLijKw9GpMldpoRPrLtGleVMa0=";
  };
}
