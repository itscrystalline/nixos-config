{
  description = "System Flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-bluez-5-75.url = "github:NixOS/nixpkgs/038fb464fcfa79b4f08131b07f2d8c9a6bcc4160";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # chaotic-nyx: cachyos kernel
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
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
    my-nur = {
      url = "github:itscrystalline/nur-packages";
    };
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # hyprland.url = "github:hyprwm/Hyprland";

    # nix-on-droid
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    #nvchad
    # nvchad4nix = {
    # };
    # neve.url = "github:itscrystalline/Neve";
    sanzenvim.url = "github:itscrystalline/sanzenvim";
    # nixvim.url = "github:nix-community/nixvim";

    # binary ninja
    binaryninja = {
      url = "github:jchv/nix-binary-ninja";

      # Optional, but recommended.
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
    nix-on-droid,
    nur,
    my-nur,
    home-manager,
    nix-darwin,
    catppuccin,
    zen-browser,
    nix-jebrains-plugins,
    blender-flake,
    nix-flatpak,
    # nvchad4nix,
    sanzenvim,
    binaryninja,
    # nixvim,
    occasion,
    nix-index-database,
    quickshell,
    vicinae,
    winapps,
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
  in rec {
    # Please replace my-nixos with your hostname
    nixosConfigurations.cwystaws-meowchine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs blender-flake secrets;
      };
      modules = [
        configs.cwystaws-meowchine
        # NUR, catppuccin, nix-flatpak, chaotic-nyx, lix
        nur.modules.nixos.default
        catppuccin.nixosModules.catppuccin
        nix-flatpak.nixosModules.nix-flatpak
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
        binaryninja.nixosModules.binaryninja

        # HW
        nixos-hardware.nixosModules.asus-fx506hm

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./vars.nix
        ./nix-settings.nix
        ./host/devices/cwystaws-meowchine/host.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./vars.nix
              ./home/home-linux.nix

              configs.cwystaws-meowchine
              catppuccin.homeModules.catppuccin
              nix-flatpak.homeManagerModules.nix-flatpak
              nix-index-database.homeModules.nix-index
              # nvchad4nix.homeManagerModule
              # nixvim.homeManagerModules.nixvim
              occasion.homeManagerModule
              vicinae.homeManagerModules.default
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit
              nixpkgs
              inputs
              zen-browser
              nix-jebrains-plugins
              nur
              blender-flake
              binaryninja
              secrets
              occasion
              sanzenvim
              quickshell
              my-nur
              vicinae
              winapps
              ;
          };
        }
      ];
    };

    darwinConfigurations."cwystaws-macbook" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs blender-flake secrets;
      };
      modules = [
        configs.cwystaws-meowchine

        ./vars.nix
        ./nix-settings.nix
        ./host/devices/cwystaws-macbook/host.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./vars.nix
              ./home/home.nix

              configs.cwystaws-meowchine
              catppuccin.homeModules.catppuccin
              nix-index-database.homeModules.nix-index
              occasion.homeManagerModule
              vicinae.homeManagerModules.default
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit
              nixpkgs
              inputs
              zen-browser
              nix-jebrains-plugins
              nur
              blender-flake
              binaryninja
              secrets
              occasion
              sanzenvim
              quickshell
              my-nur
              vicinae
              winapps
              ;
          };
        }
      ];
    };

    nixosConfigurations.cwystaws-raspi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs secrets;
      };
      modules = [
        # sd card image
        # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        # {nixpkgs.config.allowUnsupportedSystem = true;}

        configs.raspi
        # NUR, catppuccin, nix-flatpak, chaotic-nyx, lix
        nur.modules.nixos.default
        catppuccin.nixosModules.catppuccin

        # HW
        nixos-hardware.nixosModules.raspberry-pi-4

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./vars.nix
        # NUR, catppuccin, nix-flatpak, chaotic-nyx, lix
        ./nix-settings.nix
        ./host/devices/cwystaws-raspi/host.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./vars.nix
              ./home/home-linux.nix

              configs.raspi
              catppuccin.homeModules.catppuccin
              nix-flatpak.homeManagerModules.nix-flatpak
              nix-index-database.homeModules.nix-index
              # nvchad4nix.homeManagerModule
              # nixvim.homeManagerModules.nixvim
              occasion.homeManagerModule
              vicinae.homeManagerModules.default
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit
              nixpkgs
              inputs
              nur
              secrets
              occasion
              sanzenvim
              quickshell
              my-nur
              vicinae
              winapps
              ;
          };
        }
      ];
    };
    # images.cwystaws-raspi = nixosConfigurations.cwystaws-raspi.config.system.build.sdImage;

    nixosConfigurations.cwystaws-dormpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs secrets;
      };
      modules = [
        # sd card image
        # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        # {
        #   nixpkgs.config.allowUnsupportedSystem = true;
        # }

        configs.raspi
        # NUR, catppuccin, nix-flatpak, chaotic-nyx, lix
        nur.modules.nixos.default
        catppuccin.nixosModules.catppuccin

        # HW
        nixos-hardware.nixosModules.raspberry-pi-4

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./vars.nix
        ./nix-settings.nix
        ./host/devices/cwystaws-dormpi/host.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbkup";
          home-manager.users.itscrystalline = {
            imports = [
              ./vars.nix
              ./home/home-linux.nix

              configs.raspi
              catppuccin.homeModules.catppuccin
              nix-flatpak.homeManagerModules.nix-flatpak
              nix-index-database.homeModules.nix-index
              # nvchad4nix.homeManagerModule
              # nixvim.homeManagerModules.nixvim
              occasion.homeManagerModule
              vicinae.homeManagerModules.default
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit
              nixpkgs
              inputs
              nur
              secrets
              occasion
              sanzenvim
              quickshell
              my-nur
              vicinae
              winapps
              ;
          };
        }
      ];
    };
    images.cwystaws-dormpi = nixosConfigurations.cwystaws-dormpi.config.system.build.sdImage;

    # nix-on-droid
    nixOnDroidConfigurations.cwystaw-the-neko = nix-on-droid.lib.nixOnDroidConfiguration {
      system = "aarch64-linux";

      specialArgs = {inherit inputs;};

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
