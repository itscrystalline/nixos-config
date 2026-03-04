{
  description = "Crystal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixos-generators,
    home-manager,
    ...
  }: let
    # All HM modules shared by both standalone and NixOS-embedded configs.
    # Does NOT include stylix (NixOS provides it via nixosModules.stylix).
    hmModules = [
      ./modules/home-manager
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
      inputs.nix-index-database.homeModules.nix-index
      inputs.occasion.homeManagerModule
      inputs.vicinae.homeManagerModules.default
      inputs.zen-browser.homeModules.twilight
      inputs.noctalia.homeModules.default
      inputs.niri.homeModules.niri
    ];

    # Build a standalone homeManagerConfiguration (adds stylix HM module).
    # userModules: per-user HM option files (e.g. ./homes/itscrystalline.nix).
    mkStandaloneHome = system: userModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = hmModules ++ [inputs.stylix.homeModules.stylix] ++ userModules;
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
      hmUserModules ? [],
      userHomeModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        system = arch;
        specialArgs.inputs = inputs;
        modules =
          [
            inputs.nur.modules.nixos.default
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (nixosHmConfig (userHomeModules ++ hmUserModules))
          ]
          ++ [
            ./modules/nixos
            ./secrets
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
      userHomeModules = [./homes/itscrystalline.nix];
    };
    raine = mkHost {
      arch = "aarch64-linux";
      configModule = ./hosts/raine.nix;
      otherModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
      userHomeModules = [./homes/itscrystalline.nix];
    };
    liriel = mkHost {
      arch = "aarch64-linux";
      configModule = ./hosts/liriel.nix;
      otherModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
      userHomeModules = [./homes/itscrystalline.nix];
    };
  in {
    nixosConfigurations = {
      inherit rhys raine liriel;
    };

    packages.aarch64-linux = {
      raine = nixos-generators.nixosGenerate (raine // {format = "sd-aarch64";});
      liriel = nixos-generators.nixosGenerate (liriel // {format = "sd-aarch64";});
    };
    packages.x86_64-linux.docs = nixpkgs.legacyPackages.x86_64-linux.callPackage ./modules/docs.nix {};
    homeConfigurations = {
      "itscrystalline@rhys" = mkStandaloneHome "x86_64-linux" [./homes/itscrystalline.nix];
    };
  };
}
