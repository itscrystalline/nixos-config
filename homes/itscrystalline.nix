# NixOS module: configures home-manager for the itscrystalline user.
# Passthrough (gui.enable, bluetooth.enable, secrets) is set automatically
# by modules/nixos/home-manager-passthrough.nix.
{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbkup";
    extraSpecialArgs = {inherit inputs;};
    users.itscrystalline.imports = [
      ../home/home-linux.nix
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
      inputs.nix-index-database.homeModules.nix-index
      inputs.occasion.homeManagerModule
      inputs.vicinae.homeManagerModules.default
      inputs.zen-browser.homeModules.twilight
      inputs.noctalia.homeModules.default
      inputs.niri.homeModules.niri
    ];
  };
}
