{
  pkgs,
  config,
  lib,
  ...
}: let
  enabled = config.compat.steam-run.enable;
  nixLdEnabled = config.compat.nix-ld.enable;
in {
  options.compat.steam-run.enable = lib.mkEnableOption "steam-run";
  config = lib.mkIf enabled {
    environment.systemPackages = [pkgs.steam-run];

    programs.nix-ld.libraries = lib.optionals nixLdEnabled [
      (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
    ];
  };
}
