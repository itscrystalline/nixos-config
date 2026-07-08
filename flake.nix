{
  description = "Crystal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    # FIXME: until xwayland-sattelite fixes https://github.com/Supreeeme/xwayland-satellite/issues/278
    xwayland-satellite_old.url = "github:Supreeeme/xwayland-satellite/3273a0fccd71da21c6362c74f3b1d1c0a89ff3ba";
    # FIXME: remove when niri-flake updates its lockfile again
    niri-unstable.url = "github:YaLTeR/niri";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
        xwayland-satellite-unstable.follows = "xwayland-satellite_old";
        niri-unstable.follows = "niri-unstable";
      };
    };
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    blender-flake = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    sanzenvim.url = "git+https://git.iw2tryhard.dev/itscrystalline/sanzenvim";

    occasion = {
      url = "git+https://git.iw2tryhard.dev/itscrystalline/occasion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix-unstable = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    forgesync = {
      url = "git+https://git.iw2tryhard.dev/itscrystalline/forgesync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    harmonia.url = "github:nix-community/harmonia";
    concord.url = "github:chojs23/concord";
    ncro.url = "github:feel-co/ncro";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }: let
    # All HM modules shared by both standalone and NixOS-embedded configs.
    # Does NOT include stylix (NixOS provides it via nixosModules.stylix).
    hmModules = [
      ./modules/home-manager
      (import ./secrets false)
      inputs.nix-index-database.homeModules.nix-index
      inputs.occasion.homeManagerModule
      inputs.sops-nix.homeManagerModules.sops
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
          ]
          ++ userModules;
        extraSpecialArgs = {
          inherit inputs;
          spkgs = self.packages.${system};
          passthrough = null;
        };
      };

    # Inline NixOS module that wires up home-manager for the primary user.
    # hmUserModules: additional per-host HM option files.
    nixosHmConfig = hmUserModules: arch: {config, ...}: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hmbkup";
        extraSpecialArgs = {
          inherit inputs;
          spkgs = self.packages.${arch};
        };
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
        specialArgs = {
          inherit inputs;
          spkgs = self.packages.${arch};
        };
        modules =
          [
            inputs.nur.modules.nixos.default
            inputs.stylix.nixosModules.stylix
            inputs.nix-index-database.nixosModules.default
            inputs.ncro.nixosModules.default
          ]
          ++ nixpkgs.lib.optionals (userHomeModules != []) [
            home-manager.nixosModules.home-manager
            (nixosHmConfig userHomeModules arch)
          ]
          ++ [
            inputs.sops-nix.nixosModules.sops
            ./modules/nixos
            (import ./secrets true)
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
        inputs.noctalia-greeter.nixosModules.default
        nixos-hardware.nixosModules.asus-fx506hm
      ];
      userHomeModules = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.vicinae.homeManagerModules.default
        inputs.zen-browser.homeModules.twilight
        inputs.noctalia.homeModules.default
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
        inputs.forgesync.nixosModules.default
        inputs.copyparty.nixosModules.default
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
    mingzhu = mkHost rec {
      arch = "aarch64-linux";
      configModule = ./hosts/mingzhu.nix;
      otherModules = [
        inputs.nur.legacyPackages.${arch}.repos.itscrystalline.modules.ocid
        inputs.nur.legacyPackages.${arch}.repos.itscrystalline.modules.oracle-cloud-agent
        inputs.harmonia.nixosModules.harmonia
      ];
      userHomeModules = [
        (import ./homes/itscrystalline.nix {
          headless = true;
          minimal = false;
        })
      ];
    };
    # nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./hosts/jocelyn/facter.json  --flake .#jocelyn --copy-host-keys --target-host root@<ip address>
    jocelyn = mkHost {
      arch = "x86_64-linux";
      configModule = ./hosts/jocelyn.nix;
      otherModules = [
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
      ];
    };
    # nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./hosts/emily/facter.json  --flake .#emily --copy-host-keys --target-host root@<ip address>
    emily = mkHost {
      arch = "x86_64-linux";
      configModule = ./hosts/emily.nix;
      otherModules = [
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
      ];
    };
  in {
    nixosConfigurations = {
      inherit rhys raine liriel mingzhu jocelyn emily;
    };
    homeConfigurations = {
      "opc" = mkStandaloneHome "aarch64-linux" [./homes/opc.nix];
    };
    packages = import ./overridden-packages.nix {
      inherit inputs;
      pkgs-x86_64 = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-linux";
        overlays = [
          (_: prev: {
            unstable = import inputs.nixpkgs-unstable {
              config.allowUnfree = true;
              inherit (prev.stdenv.hostPlatform) system;
            };
          })
        ];
      };
      pkgs-aarch64 = import nixpkgs {
        config.allowUnfree = true;
        system = "aarch64-linux";
        overlays = [
          (_: prev: {
            unstable = import inputs.nixpkgs-unstable {
              config.allowUnfree = true;
              inherit (prev.stdenv.hostPlatform) system;
            };
          })
        ];
      };
    };
  };
}
