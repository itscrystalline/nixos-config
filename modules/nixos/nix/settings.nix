{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://sanzenvim.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://niri.cachix.org"
        "http://cache${config.crystals-services.nginx.localSuffix}"
        "https://cuda-maintainers.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "cwystaws-raspi:2xuwbE44tVXZdoV8OJYaTXJT1PoKF3nD0fc9dDix41s="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
      access-tokens = "github.com=${config.secrets.ghToken}";
      trusted-users = ["root" "itscrystalline" "nixremote" "opc" "ubuntu"];
      auto-optimise-store = true;
    };

    nixPath =
      [
        "nixpkgs=${inputs.nixpkgs}"
        "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
        "nur=${inputs.nur}"
        "nixos-hardware=${inputs.nixos-hardware}"
        "home-manager=${inputs.home-manager}"
        "stylix=${inputs.stylix}"
        "stylix-unstable=${inputs.stylix-unstable}"
      ]
      ++ lib.optionals config.gui.enable [
        "zen-browser=${inputs.zen-browser}"
        "nix-flatpak=${inputs.nix-flatpak}"
        "niri=${inputs.niri}"
      ];

    package = pkgs.lixPackageSets.stable.lix;

    extraOptions = ''
      builders-use-substitutes = true
    '';

    buildMachines = [
      {
        hostName = "cwystaws-siwwybowox";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 8;
        speedFactor = 2;
        supportedFeatures = [];
        mandatoryFeatures = [];
      }
      {
        hostName = "raine";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = 1;
        supportedFeatures = [];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (_: prev: {
      stable = prev;
      hostsys = prev.stdenv.hostPlatform.system;
      unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit (prev.stdenv.hostPlatform) system;
      };

      inherit
        (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
    inputs.niri.overlays.niri
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  system.stateVersion = "24.11";
}
