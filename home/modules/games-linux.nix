{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) gui;
  cfg = config.crystal.hm.gamesLinux;
in {
  imports = [./games.nix];
  options.crystal.hm.gamesLinux.enable = lib.mkEnableOption "Linux games" // {default = true;};
  config = lib.mkIf cfg.enable (lib.mkIf gui {
    home.packages = with pkgs; [bottles];
    services.flatpak.packages = [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
    ];
  });
}
