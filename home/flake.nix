{
  description = "Home Manager configuration of opc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    neve.url = "github:itscrystalline/Neve";
    # nixvim.url = "github:nix-community/nixvim";

    occasion.url = "github:itscrystalline/occasion";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    neve,
    catppuccin,
    zen-browser,
    nix-jebrains-plugins,
    nur,
    blender-flake,
    nix-flatpak,
    occasion,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    home_config = username: extraConfig:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./../vars.nix

          {
            config.gui = false;
            config.username = username;
          }
          extraConfig

          ({inputs, ...}: {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import inputs.nixpkgs {
                  config.allowUnfree = true;
                  system = prev.system;
                };
              })
            ];
          })

          ./home.nix

          catppuccin.homeModules.catppuccin
          nix-flatpak.homeManagerModules.nix-flatpak
          occasion.homeManagerModule
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit nixpkgs;
          inherit zen-browser;
          inherit nix-jebrains-plugins;
          inherit nur;
          inherit blender-flake;
          inherit occasion;
          inherit neve;
        };
      };
  in {
    homeConfigurations."opc" = home_config "opc" {config.doas = false;};
    homeConfigurations."ubuntu" = home_config "ubuntu" {config.doas = false;};
    homeConfigurations."itscrystalline" = home_config "itscrystalline";
  };
}
