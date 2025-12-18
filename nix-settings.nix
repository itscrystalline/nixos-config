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
        "https://niri.cachix.org"
        "http://cache.crys"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "cwystaws-raspi:2xuwbE44tVXZdoV8OJYaTXJT1PoKF3nD0fc9dDix41s="
      ];
      access-tokens = "github.com=${secrets.ghToken}";
      # post-build-hook = "${./post-build-hook.sh}";
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
        "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
        "nur=${inputs.nur}"
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "darwin=${inputs.nix-darwin}"
      ]
      ++ lib.optionals pkgs.stdenv.isLinux ([
          "nixos-hardware=${inputs.nixos-hardware}"
          "home-manager=${inputs.home-manager}"
          "stylix=${inputs.stylix}"
          "stylix-unstable=${inputs.stylix-unstable}"
        ]
        ++ lib.optionals config.gui [
          "zen-browser=${inputs.zen-browser}"
          "nix-flatpak=${inputs.nix-flatpak}"
          "niri=${inputs.niri}"
          "ignis=${inputs.ignis}"
        ]);
    package = pkgs.lixPackageSets.stable.lix;

    # make devenv shut up
    extraOptions = ''
      builders-use-substitutes = true
    '';

    # remote buliders
    buildMachines = lib.optionals pkgs.stdenv.isLinux [
      {
        hostName = "cwystaws-siwwybowox";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        # if the builder supports building for multiple architectures,
        # replace the previous line by, e.g.
        # systems = ["x86_64-linux" "aarch64-linux"];
        maxJobs = 8;
        speedFactor = 2;
        supportedFeatures = [];
        mandatoryFeatures = [];
      }
      # {
      #   hostName = "cwystaws-grass-box";
      #   system = "aarch64-linux";
      #   protocol = "ssh-ng";
      #   # if the builder supports building for multiple architectures,
      #   # replace the previous line by, e.g.
      #   # systems = ["x86_64-linux" "aarch64-linux"];
      #   maxJobs = 8;
      #   speedFactor = 2;
      #   supportedFeatures = [];
      #   mandatoryFeatures = [];
      # }
    ];
    distributedBuilds = pkgs.stdenv.isLinux;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # unstable overlay
  nixpkgs.overlays = [
    (_: prev: rec {
      stable = prev;
      hostsys = prev.stdenv.hostPlatform.system;
      unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit hostsys;
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
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  # NO I DID NOT
}
