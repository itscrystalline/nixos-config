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
  };

  outputs = inputs@{ nixpkgs, home-manager, nvchad4nix, catppuccin, ... }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."opc" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;


        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./../nix-settings.nix
          ./../vars.nix
          ./home.nix

          catppuccin.homeManagerModules.catppuccin
          nvchad4nix.homeManagerModule        
        ];
        gui = false;
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
