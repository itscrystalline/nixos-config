{
  config,
  inputs,
  pkgs,
  ...
}: {
  sops.secrets.gh-token.restartUnits = ["nix-daemon.service"];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://cache.nixos.org"
        "http://cache.crys"
      ];

      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "mingzhu:V0KsUipFnrBNsfUD8VI0rFXQpgE3KKJfRby9Jm8cLTQ="
      ];

      trusted-users = ["root" "itscrystalline" "nixremote" "@wheel"];
      auto-optimise-store = true;
      fallback = true;
      builders-use-substitutes = true;
    };

    nixPath = map (i: "${i}=${inputs.${i}}") (builtins.attrNames inputs);

    extraOptions = ''
      include ${config.sops.templates.nix-extra-config.path}
    '';
    checkConfig = false;

    package = pkgs.lixPackageSets.stable.lix;
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
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.niri.overlays.niri
  ];

  system.stateVersion = "24.11";
}
