{config, ...}: {
  home.homeDirectory = "/home/${config.username}";
  imports = [
    ./home.nix

    ./modules/nextcloud.nix
    ./modules/gui-linux.nix
    ./modules/games-linux.nix
    ./modules/flatpak.nix
    ./modules/virtualisation.nix
    ./modules/services.nix

    ./modules/niri.nix
    ./modules/ignis.nix
  ];
}
