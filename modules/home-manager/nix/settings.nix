{
  lib,
  inputs ? {},
  passthrough ? null,
  pkgs,
  config,
  ...
}:
lib.mkIf (passthrough == null) {
  sops.templates."nix-extra-config".content = ''
    access-tokens = github.com=${config.sops.placeholder."gh-token"}
  '';
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-python.cachix.org"
        "https://niri.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://itscrystalline.cachix.org"
        "http://cache.crys"
      ];

      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "itscrystalline.cachix.org-1:w+aEu6k5Rx3xgUSJPCUhdZSxS919ZJvv9wThPKGVMv4="
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
      include ${config.sops.templates."nix-extra-config".path}
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
