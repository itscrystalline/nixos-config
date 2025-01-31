{
  description = "System Flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-bluez-5-75.url = "github:NixOS/nixpkgs/038fb464fcfa79b4f08131b07f2d8c9a6bcc4160";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # chaotic-nyx: cachyos kernel
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # hyprland.url = "github:hyprwm/Hyprland";
    # ags.url = "github:Aylur/ags/v1";

    # nix-on-droid
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    #nvchad
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, chaotic, nixos-hardware, nix-on-droid, nur, home-manager, catppuccin, zen-browser, nix-jebrains-plugins, blender-flake, nix-flatpak, nvchad4nix, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.cwystaws-meowchine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs blender-flake; };
      modules = [
        # NUR, catppuccin, nix-flatpak, chaotic-nyx
        nur.modules.nixos.default
        catppuccin.nixosModules.catppuccin
        nix-flatpak.nixosModules.nix-flatpak
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry

        # HW
        nixos-hardware.nixosModules.asus-fx506hm

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./nix-settings.nix
        ./host/devices/cwystaws-meowchine/host.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./home/home.nix

              catppuccin.homeManagerModules.catppuccin
              nix-flatpak.homeManagerModules.nix-flatpak
              nvchad4nix.homeManagerModule
            ];
          };

       	  home-manager.extraSpecialArgs = {
       	    inherit inputs;
       	    inherit zen-browser;
       	    inherit nix-jebrains-plugins;
            inherit nur;
            inherit blender-flake;
       	  };
        }
      ];
    };

    # nix-on-droid
    nixOnDroidConfigurations.cwystaw-the-neko = nix-on-droid.lib.nixOnDroidConfiguration {
      system = "aarch64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        ./nix-settings.nix
        ./host/devices/cwystaw-the-neko/host.nix
      ];

      nixpkgs.overlays = [
        nix-on-droid.overlays.default
      ];

      home-manager-path = home-manager.outPath;
    };
  };
}
