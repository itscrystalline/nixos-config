# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}: {
  nix = {
    settings = {
      # Nix Flakes
      experimental-features = ["nix-command" "flakes"];

      # Cachixes
      substituters = [
        "https://devenv.cachix.org"
        "https://sanzenvim.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "http://cache.crys"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "cwystaws-raspi:2xuwbE44tVXZdoV8OJYaTXJT1PoKF3nD0fc9dDix41s="
      ];
      access-tokens = "github.com=${secrets.ghToken}";
      # post-build-hook = "${../post-build-hook.sh}";
      trusted-users = ["root" "itscrystalline" "nixremote" "opc" "ubuntu"];

      # Optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
    };

    # NIX_PATH
    nixPath =
      [
        "nixpkgs=${inputs.nixpkgs}"
        "nur=${inputs.nur}"
      ]
      ++ lib.optionals pkgs.stdenv.isLinux ([
          "home-manager=${inputs.home-manager}"
          "catppuccin=${inputs.catppuccin}"
        ]
        ++ lib.optionals config.gui [
          "zen-browser=${inputs.zen-browser}"
          "nix-jebrains-plugins=${inputs.nix-jebrains-plugins}"
        ]);
    package = pkgs.lixPackageSets.stable.lix;

    # make devenv shut up
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # unstable overlay
  nixpkgs.overlays = [
    (_: prev: {
      stable = import inputs.nixpkgs {
        config.allowUnfree = true;
        inherit (prev) system;
      };
      unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit (prev) system;
      };

      inherit
        (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];
}
