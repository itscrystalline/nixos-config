{
  description = "Home Manager configuration of opc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
    vicinae.url = "github:vicinaehq/vicinae";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ignis = {
      url = "github:ignis-sh/ignis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    secrets = builtins.fromJSON (builtins.readFile ../secrets/secrets.json);
    oracle-cloud = username: doas: {
      config = {
        inherit doas username;
        gui = false;
        keep_generations = 5;
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
              (_: prev: {
                unstable = import inputs.nixpkgs {
                  config.allowUnfree = true;
                  inherit (prev) system;
                };
              })
            ];
          })

          ./home-linux.nix

          ./nix-settings.nix

          inputs.stylix.homeModules.stylix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.occasion.homeManagerModule
          inputs.nix-index-database.homeModules.nix-index
          inputs.vicinae.homeManagerModules.default
          inputs.zen-browser.homeModules.twilight
          inputs.niri.homeModules.niri
          inputs.ignis.homeManagerModules.default
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs nixpkgs secrets;
        };
      };
  in {
    homeConfigurations."opc" = home_config "opc" false;
    homeConfigurations."ubuntu" = home_config "ubuntu" false;
    homeConfigurations."itscrystalline" = home_config "itscrystalline" true;
  };
}
