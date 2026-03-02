{lib, ...}: {
  imports = [./cli.nix ./gui.nix];

  options.programs.enable = lib.mkEnableOption "Programs";
}
