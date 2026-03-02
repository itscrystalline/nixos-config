{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) blender-flake;
  cfg = config.crystal.hm.blender;
  blender_addons_zip_path = "~/.config/blender/4.3/extensions/zips";
  blender_addons_path = "~/.config/blender/4.3/extensions/user_default";
  blender_addons_script = ''
    for file in ${blender_addons_zip_path}/*.zip; do
        if [ -f "$file" ]; then
            ${pkgs.unzip}/bin/unzip -u "$file" -d ${blender_addons_path}
        fi
    done
  '';

  blenderkit_version = "3.13.0.241112";
  blenderkit_sha256 = "wrMUz6OzTBDe0rbqXqiizWo72jRdM7ut4TXVV/3KmzA==";
in {
  options.crystal.hm.blender.enable = lib.mkEnableOption "Blender";
  config = lib.mkIf cfg.enable (lib.mkIf (config.gui && pkgs.hostsys == "x86_64-linux") {
    home.packages = with pkgs; [
      (blender-flake.packages.${pkgs.hostsys}.default.overrideAttrs (oldAttrs: newAttrs: let
        libs = [
          wayland
          libdecor
          xorg.libX11
          xorg.libXi
          xorg.libXxf86vm
          xorg.libXfixes
          xorg.libXrender
          libxkbcommon
          libGLU
          libglvnd
          numactl
          SDL2
          libdrm
          ocl-icd
          stdenv.cc.cc.lib
          openal
          xorg.libSM
          xorg.libICE
          zlib
        ];
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
    home.file.".scripts/blender-plugins.sh".source = pkgs.writeShellScript "blender-plugins.sh" ''${blender_addons_script}'';
    home.activation.blender-addons = lib.hm.dag.entryAfter ["writeBoundary"] ''~/.scripts/blender-plugins.sh'';

    xdg.configFile = {
      "blender/4.3/extensions/zips/blenderkit.zip".source = pkgs.fetchurl {
        url = "https://github.com/BlenderKit/BlenderKit/releases/download/v${blenderkit_version}/blenderkit-v${blenderkit_version}.zip";
        sha256 = "sha256-${blenderkit_sha256}";
      };
    };
  });
}
