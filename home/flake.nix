{
  description = "Home Manager configuration of opc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jebrains-plugins.url = "github:theCapypara/nix-jebrains-plugins";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nvchad4nix,
    catppuccin,
    zen-browser,
    nix-jebrains-plugins,
    nur,
    blender-flake,
    nix-flatpak,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."opc" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./../vars.nix
        ./home.nix

        catppuccin.homeManagerModules.catppuccin
        nix-flatpak.homeManagerModules.nix-flatpak
        nvchad4nix.homeManagerModule
      ];
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        inherit inputs;
        inherit zen-browser;
        inherit nix-jebrains-plugins;
        inherit nur;
        inherit blender-flake;
      };
    };
  };
}
