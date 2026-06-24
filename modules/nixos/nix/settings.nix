{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  sops.secrets.gh-token.restartUnits = ["nix-daemon.service"];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      substituters = lib.mkForce ["http://localhost${config.services.ncro.settings.server.listen}"];

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

  niri-flake.cache.enable = false;

  crystals-services.nix-binary-cache.ncro = {
    enable = true;
    nixCaches = [
      {
        url = "https://cache.nixos.org";
        public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
      }
      {
        url = "https://devenv.cachix.org";
        public_key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
      }
      {
        url = "https://nix-community.cachix.org";
        public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      }
      {
        url = "https://nixpkgs-python.cachix.org";
        public_key = "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=";
      }
      {
        url = "https://cuda-maintainers.cachix.org";
        public_key = "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=";
      }
      {
        url = "https://attic.xuyh0120.win/lantian";
        public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
      }
      {
        url = "https://niri.cachix.org";
        public_key = "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=";
      }
      {
        url = "https://itscrystalline.cachix.org";
        public_key = "itscrystalline.cachix.org-1:w+aEu6k5Rx3xgUSJPCUhdZSxS919ZJvv9wThPKGVMv4=";
      }
      {
        url = "https://vicinae.cachix.org";
        public_key = "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=";
      }
      {
        url = "https://noctalia.cachix.org";
        public_key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
      }
      {
        url = "http://harmonia.cache.crys";
        public_key = "harmonia.cache.crys:5IjKpw7rA9DxB2BVvDY/NzD0Zakjn9t9SB40AEpY2Q8=";
      }
    ];
  };

  system.stateVersion = "24.11";
}
