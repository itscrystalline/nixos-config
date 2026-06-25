{
  lib,
  config,
  pkgs,
  spkgs,
  inputs ? {},
  ...
}: let
  inherit (inputs) blender-flake;
  inherit (config.hm.programs.gui) largePrograms;
  enabled = largePrograms.enable && config.hm.gui.enable;
  themeEnabled = config.theming.enable && config.gui.enable;

  inherit (spkgs) blender;
  blender_version = builtins.concatStringsSep "." (lib.dropEnd 1 (builtins.splitVersion (lib.getVersion blender)));

  blender_addons_zip_path = "~/.config/blender/${blender_version}/extensions/zips";
  blender_addons_path = "~/.config/blender/${blender_version}/extensions/user_default";
  blender_addons_script = ''
    for file in ${blender_addons_zip_path}/*.zip; do
        if [ -f "$file" ]; then
            zip_name=$(basename "$file" .zip)

            top_level_count=$(${lib.getExe pkgs.unzip} -o -Z1 "$file" \
                | cut -d'/' -f1 \
                | sort -u \
                | wc -l)

            if [ "$top_level_count" -gt 1 ]; then
                ${lib.getExe pkgs.unzip} -u "$file" -d ${blender_addons_path}/"$zip_name"
            else
                ${lib.getExe pkgs.unzip} -u "$file" -d ${blender_addons_path}
            fi
        fi
    done
  '';

  blenderkit_version = "3.18.1.251219";
  blenderkit_sha256 = "sha256-mfzLE1HrvBIcujxehCTlLwet0Bf5vSQPde6jZ166+mg=";
in {
  config = lib.mkIf (enabled && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) {
    home = {
      packages = lib.optionals (inputs ? blender-flake) [blender];
      # activation.blender-addons = lib.hm.dag.entryAfter ["writeBoundary"] blender_addons_script;
    };

    xdg.configFile = {
      "blender/${blender_version}/extensions/zips/blenderkit.zip".source = pkgs.fetchurl {
        url = "https://github.com/BlenderKit/BlenderKit/releases/download/v${blenderkit_version}/blenderkit-v${blenderkit_version}.zip";
        sha256 = blenderkit_sha256;
      };
      "blender/${blender_version}/extensions/zips/catppucin4blender.zip".source = pkgs.fetchurl {
        url = "https://extensions.blender.org/media/files/07/07cfa54f72bd154b178e98d4dd49a722de9f35fe2c1104aa214c61116226a875.zip?filename=catppucin4blender.zip";
        name = "catppucin4blender.zip";
        sha256 = "sha256-B8+lT3K9FUsXjpjU3UmnIt6fNf4sEQSqIUxhEWImqHU=";
      };
    };
  };
}
