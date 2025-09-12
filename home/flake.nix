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
    my-nur = {
      url = "github:itscrystalline/nur-packages";
    };
    blender-flake.url = "github:edolstra/nix-warez?dir=blender";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    sanzenvim.url = "github:itscrystalline/sanzenvim";
    # nixvim.url = "github:nix-community/nixvim";

    occasion.url = "github:itscrystalline/occasion";
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
    ags.url = "github:Aylur/ags/v1";
    vicinae.url = "github:vicinaehq/vicinae";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    sanzenvim,
    catppuccin,
    zen-browser,
    nix-jebrains-plugins,
    nur,
    blender-flake,
    nix-flatpak,
    occasion,
    nix-index-database,
    quickshell,
    ags,
    my-nur,
    vicinae,
    winapps,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    oracle-cloud = username: doas: {
      config = {
        gui = false;
        doas = doas;
        keep_generations = 5;
        username = username;
      };
    };
    home_config = username: doas:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./../vars.nix

          (oracle-cloud username doas)

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

          ./home-linux.nix

          catppuccin.homeModules.catppuccin
          nix-flatpak.homeManagerModules.nix-flatpak
          occasion.homeManagerModule
          nix-index-database.hmModules.nix-index
          vicinae.homeManagerModules.default
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
          inherit sanzenvim;
          inherit quickshell;
          inherit ags;
          inherit my-nur;
          inherit vicinae;
          inherit winapps;
        };
      };
  in {
    homeConfigurations."opc" = home_config "opc" false;
    homeConfigurations."ubuntu" = home_config "ubuntu" false;
    homeConfigurations."itscrystalline" = home_config "itscrystalline" true;
  };
}
