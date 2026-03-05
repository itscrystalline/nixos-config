{lib, ...}: {
  imports = [
    ./niri.nix
    ./shell.nix
    ./flatpak.nix
    ./vicinae.nix
  ];
  options.hm.gui.enable = lib.mkEnableOption "GUI configuration";
}
