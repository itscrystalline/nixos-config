{
  description = "Crystal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    my-nur.url = "github:itscrystalline/nur-packages";
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    sanzenvim.url = "github:itscrystalline/sanzenvim";
    iw2tryhard-dev.url = "github:itscrystalline/iw2tryhard-dev-3.0";
    occasion.url = "github:itscrystalline/occasion";
    vicinae.url = "github:vicinaehq/vicinae";
    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix-unstable.url = "github:nix-community/stylix";
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }: let
    # All HM modules shared by both standalone and NixOS-embedded configs.
    # Does NOT include stylix (NixOS provides it via nixosModules.stylix).
    hmModules = [
      ./modules/home-manager
      ./secrets
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
      inputs.nix-index-database.homeModules.nix-index
      inputs.occasion.homeManagerModule
      inputs.vicinae.homeManagerModules.default
      inputs.zen-browser.homeModules.twilight
      inputs.noctalia.homeModules.default
      inputs.sops-nix.homeManagerModules.sops
      (import ./secrets/runtime.nix false)
    ];

    # Build a standalone homeManagerConfiguration (adds stylix HM module).
    # userModules: per-user HM option files (e.g. ./homes/itscrystalline.nix).
    mkStandaloneHome = system: userModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules =
          hmModules
          ++ [
            inputs.stylix.homeModules.stylix
            inputs.niri.homeModules.niri
          ]
          ++ userModules;
        extraSpecialArgs = {
          inherit inputs;
          passthrough = null;
        };
      };

    # Inline NixOS module that wires up home-manager for the primary user.
    # hmUserModules: additional per-host HM option files.
    nixosHmConfig = hmUserModules: {config, ...}: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hmbkup";
        extraSpecialArgs = {inherit inputs;};
        users.${config.core.primaryUser}.imports = hmModules ++ hmUserModules;
      };
    };

    mkHost = {
      arch,
      configModule,
      otherModules ? [],
      userHomeModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        system = arch;
        specialArgs.inputs = inputs;
        modules =
          [
            inputs.nur.modules.nixos.default
            inputs.stylix.nixosModules.stylix
          ]
          ++ nixpkgs.lib.optionals (userHomeModules != []) [
            home-manager.nixosModules.home-manager
            (nixosHmConfig userHomeModules)
          ]
          ++ [
            inputs.sops-nix.nixosModules.sops
            ./modules/nixos
            ./secrets
            (import ./secrets/runtime.nix true)
            configModule
          ]
          ++ otherModules;
      };

    rhys = mkHost {
      arch = "x86_64-linux";
      configModule = ./hosts/rhys.nix;
      otherModules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.niri.nixosModules.niri
        nixos-hardware.nixosModules.asus-fx506hm
      ];
      userHomeModules = [
        (import ./homes/itscrystalline.nix {
          nextcloudMount = true;
          minimal = false;
        })
      ];
    };
    raine = mkHost {
      arch = "aarch64-linux";
      configModule = ./hosts/raine.nix;
      otherModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
      userHomeModules = [
        (import ./homes/itscrystalline.nix {
          headless = true;
          minimal = true;
        })
      ];
    };
    liriel = mkHost {
      arch = "aarch64-linux";
      configModule = ./hosts/liriel.nix;
      otherModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
      userHomeModules = [];
    };
  in {
    nixosConfigurations = {
      inherit rhys raine liriel;
    };
    homeConfigurations = {
      "opc" = mkStandaloneHome "aarch64-linux" [./homes/opc.nix];
    };
    packages = {
      aarch64-linux.docs = nixpkgs.legacyPackages.aarch64-linux.callPackage ./modules/docs.nix {};
      x86_64-linux.docs = nixpkgs.legacyPackages.x86_64-linux.callPackage ./modules/docs.nix {};
    };
  };
}
