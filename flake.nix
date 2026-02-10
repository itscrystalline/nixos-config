{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix-unstable.url = "github:nix-community/stylix";
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
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    nixos-generators,
    home-manager,
    nix-darwin,
    ...
  }: let
    secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
    hosts = import ./hosts.nix;

    # Shared home-manager configuration
    mkHome = hostCfg: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hmbkup";
        users.itscrystalline = {
          imports =
            [
              ./vars.nix
              ./home/home-linux.nix

              {config = hostCfg.vars;}
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.nix-index-database.homeModules.nix-index
              inputs.occasion.homeManagerModule
              inputs.vicinae.homeManagerModules.default
              inputs.zen-browser.homeModules.twilight
              inputs.noctalia.homeModules.default
            ]
            ++ hostCfg.hm
            ++ nixpkgs.lib.optionals (hostCfg.extraHmConfig != {}) [hostCfg.extraHmConfig];
        };

        extraSpecialArgs = {
          inherit inputs secrets;
        };
      };
    };

    # Build a NixOS system configuration
    mkNixos = {
      hostCfg,
      system,
      extraModules ? [],
      withHome ? true,
    }: {
      inherit system;
      specialArgs = {
        inherit inputs secrets;
      };
      modules =
        [
          {config = hostCfg.vars;}
          inputs.nur.modules.nixos.default
          inputs.stylix.nixosModules.stylix
        ]
        ++ extraModules
        ++ [
          ./vars.nix
          ./nix-settings.nix
          hostCfg.hostModule
        ]
        ++ nixpkgs.lib.optionals (hostCfg.extraNixosConfig != {}) [hostCfg.extraNixosConfig]
        ++ nixpkgs.lib.optionals withHome [
          home-manager.nixosModules.home-manager
          (mkHome hostCfg)
        ];
    };

    cwystaws-meowchine = mkNixos {
      hostCfg = hosts.cwystaws-meowchine;
      system = "x86_64-linux";
      extraModules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.niri.nixosModules.niri
        inputs.binaryninja.nixosModules.binaryninja
        nixos-hardware.nixosModules.asus-fx506hm
      ];
    };

    mkRaspi = {
      hostCfg,
      withHome,
    }: mkNixos {
      inherit hostCfg withHome;
      system = "aarch64-linux";
      extraModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
    };
  in {
    nixosConfigurations = {
      cwystaws-meowchine = nixpkgs.lib.nixosSystem cwystaws-meowchine;
      cwystaws-raspi = nixpkgs.lib.nixosSystem (mkRaspi {hostCfg = hosts.cwystaws-raspi; withHome = true;});
      cwystaws-dormpi = nixpkgs.lib.nixosSystem (mkRaspi {hostCfg = hosts.cwystaws-dormpi; withHome = false;});
    };

    packages.aarch64-linux = {
      cwystaws-raspi = nixos-generators.nixosGenerate ((mkRaspi {hostCfg = hosts.cwystaws-raspi; withHome = true;}) // {format = "sd-aarch64";});
      cwystaws-dormpi = nixos-generators.nixosGenerate ((mkRaspi {hostCfg = hosts.cwystaws-dormpi; withHome = false;}) // {format = "sd-aarch64";});
    };

    darwinConfigurations."cwystaws-macbook" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs secrets;
      };
      modules =
        [
          {config = hosts.cwystaws-macbook.vars;}

          ./vars.nix
          ./nix-settings.nix
          hosts.cwystaws-macbook.hostModule

          inputs.stylix.darwinModules.stylix
          home-manager.darwinModules.home-manager
          (mkHome hosts.cwystaws-macbook)
        ]
        ++ nixpkgs.lib.optionals (hosts.cwystaws-macbook.extraNixosConfig != {}) [hosts.cwystaws-macbook.extraNixosConfig];
    };
  };
}
