{
  lib,
  config,
  inputs ? {},
  passthrough ? null,
  pkgs,
  ...
}: let
  guiEnabled = config.hm.gui.enable;
in
  lib.mkIf (passthrough == null) {
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];

        substituters =
          [
            "https://cache.nixos.org"
            "https://devenv.cachix.org"
            "https://sanzenvim.cachix.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-python.cachix.org"
            "https://niri.cachix.org"
            "https://cuda-maintainers.cachix.org"
          ]
          ++ lib.optionals guiEnabled [
            "http://cache.crys"
          ];

        trusted-public-keys = [
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "cwystaws-raspi:2xuwbE44tVXZdoV8OJYaTXJT1PoKF3nD0fc9dDix41s="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];

        access-tokens = "github.com=${config.secrets.ghToken}";
        trusted-users = ["root" "itscrystalline" "nixremote" "opc" "ubuntu"];
        auto-optimise-store = true;
      };

      nixPath =
        [
          "nixpkgs=${inputs.nixpkgs or ""}"
          "nur=${inputs.nur or ""}"
          "home-manager=${inputs.home-manager or ""}"
          "stylix=${inputs.stylix or ""}"
        ]
        ++ lib.optionals guiEnabled [
          "zen-browser=${inputs.zen-browser or ""}"
          "niri=${inputs.niri or ""}"
        ];

      package = pkgs.lixPackageSets.stable.lix;

      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (_: prev: {
        stable = prev;
        hostsys = prev.stdenv.hostPlatform.system;
        unstable = prev;
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ]
    ++ lib.optional (inputs ? niri) inputs.niri.overlays.niri;
  }
