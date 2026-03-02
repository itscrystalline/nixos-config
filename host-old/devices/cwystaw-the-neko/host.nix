{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ../../modules/programs.nix
    ../../modules/localization.nix
    ../../modules/compat.nix
  ];
}
