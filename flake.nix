{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # chaotic-nyx: cachyos kernel
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jebrains-plugins.url = "github:theCapypara/nix-jebrains-plugins";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nur.url = "github:itscrystalline/nur-packages";
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    sanzenvim.url = "github:itscrystalline/sanzenvim";
    binaryninja = {
      url = "github:jchv/nix-binary-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iw2tryhard-dev.url = "github:itscrystalline/iw2tryhard-dev-3.0";
    occasion.url = "github:itscrystalline/occasion";
    suwayomi.url = "github:NixOS/nixpkgs?ref=pull/400589/head";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    chaotic,
    nixos-hardware,
    nixos-generators,
    home-manager,
    nix-darwin,
    ...
  }: let
    secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
    configs = {
      cwystaws-meowchine.config = {
        gui = true;
        doas = true;
        keep_generations = 5;
        username = "itscrystalline";
      };

      raspi.config = {
        gui = false;
        doas = true;
        keep_generations = 3;
        username = "itscrystalline";
      };
    };

    home = raspi: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hmbkup";
        users.itscrystalline = {
          imports = [
            ./vars.nix
            ./home/home-linux.nix

            (
              if raspi
              then configs.raspi
              else configs.cwystaws-meowchine
            )
            inputs.catppuccin.homeModules.catppuccin
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.nix-index-database.homeModules.nix-index
            inputs.occasion.homeManagerModule
            inputs.vicinae.homeManagerModules.default
          ];
        };

        extraSpecialArgs = {
          inherit inputs secrets;
        };
      };
    };

    cwystaws-meowchine = {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs secrets;
      };
      modules = [
        configs.cwystaws-meowchine
        inputs.nur.modules.nixos.default
        inputs.catppuccin.nixosModules.catppuccin
        inputs.nix-flatpak.nixosModules.nix-flatpak
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
        inputs.binaryninja.nixosModules.binaryninja
        nixos-hardware.nixosModules.asus-fx506hm

        ./vars.nix
        ./nix-settings.nix
        ./host/devices/cwystaws-meowchine/host.nix

        home-manager.nixosModules.home-manager
        (home false)
      ];
    };
    raspis = module: {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs secrets;
      };
      modules = [
        configs.raspi
        inputs.nur.modules.nixos.default
        inputs.catppuccin.nixosModules.catppuccin
        nixos-hardware.nixosModules.raspberry-pi-4

        ./vars.nix
        ./nix-settings.nix
        module

        home-manager.nixosModules.home-manager
        (home true)
      ];
    };
  in {
    nixosConfigurations = {
      cwystaws-meowchine = nixpkgs.lib.nixosSystem cwystaws-meowchine;
      cwystaws-raspi = nixpkgs.lib.nixosSystem (raspis ./host/devices/cwystaws-raspi/host.nix);
      cwystaws-dormpi = nixpkgs.lib.nixosSystem (raspis ./host/devices/cwystaws-dormpi/host.nix);
    };

    packages.aarch64-linux = {
      cwystaws-raspi = nixos-generators.nixosGenerate ((raspis ./host/devices/cwystaws-raspi/host.nix) // {format = "sd-aarch64";});
      cwystaws-dormpi = nixos-generators.nixosGenerate ((raspis ./host/devices/cwystaws-dormpi/host.nix) // {format = "sd-aarch64";});
    };

    darwinConfigurations."cwystaws-macbook" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs secrets;
      };
      modules = [
        configs.cwystaws-meowchine

        ./vars.nix
        ./nix-settings.nix
        ./host/devices/cwystaws-macbook/host.nix

        home-manager.darwinModules.home-manager
        (home false)
      ];
    };
  };
}
