{
  pkgs,
  config,
  ...
} @ inputs: {
  home.homeDirectory = "/home/itscrystalline";
  imports = [
    ./home.nix

    ./modules/nextcloud.nix
    ./modules/ags.nix
    ./modules/gui-linux.nix
    ./modules/games-linux.nix
    ./modules/flatpak.nix
    ./modules/virtualisation.nix
    ./modules/services.nix
  ];
}
