{
  lib,
  inputs ? {},
  passthrough ? null,
  pkgs,
  config,
  ...
}:
lib.mkIf (passthrough == null) {
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
      builders-use-substitutes = true;
      fallback = true;
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs or ""}"
      "nur=${inputs.nur or ""}"
      "home-manager=${inputs.home-manager or ""}"
      "stylix=${inputs.stylix or ""}"
      "zen-browser=${inputs.zen-browser or ""}"
      "niri=${inputs.niri or ""}"
    ];

    package = pkgs.lixPackageSets.stable.lix;

    extraOptions = ''
      include ${config.sops.templates.nix-extra-config.path}
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
    inputs.niri.overlays.niri
  ];
}
