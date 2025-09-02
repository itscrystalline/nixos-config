{
  config,
  lib,
  ...
}: let
  inherit (config) gui;
in {
  imports = [./games.nix];
  config = lib.mkIf gui {
    services.flatpak.packages = [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
      "us.zoom.Zoom"
    ];
  };
}
