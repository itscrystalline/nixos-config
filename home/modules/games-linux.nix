{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) gui;
in {
  imports = [./games.nix];
  config = lib.mkIf gui {
    home.packages = with pkgs; [bottles];
    services.flatpak.packages = [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
    ];
  };
}
