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

      substituters = lib.mkForce ["http://cache.crys"];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "itscrystalline.cachix.org-1:w+aEu6k5Rx3xgUSJPCUhdZSxS919ZJvv9wThPKGVMv4="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "harmonia.cache.crys:5IjKpw7rA9DxB2BVvDY/NzD0Zakjn9t9SB40AEpY2Q8="
      ];

      trusted-users = ["root" "itscrystalline" "nixremote" "@wheel"];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      fallback = true;
    };

    nixPath = map (i: "${i}=${inputs.${i}}") (builtins.attrNames inputs);

    # seems like an oxymoron but ironically lix stable on stable fails to build
    package = pkgs.unstable.lixPackageSets.stable.lix;

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
