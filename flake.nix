{
  description = "System Flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
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
    # hyprland.url = "github:hyprwm/Hyprland";
    # ags.url = "github:Aylur/ags/v1";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, nur, home-manager, catppuccin, zen-browser, nix-jebrains-plugins, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.cwystaws-meowchine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # NUR
        nur.modules.nixos.default
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix

        catppuccin.nixosModules.catppuccin

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./home/home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };

       	  home-manager.extraSpecialArgs = {
       	    inherit inputs;
       	    inherit zen-browser;
       	    inherit nix-jebrains-plugins;
            inherit nur;
       	  };
        }
      ];
    };
  };
}
