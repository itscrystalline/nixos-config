# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  blender-flake,
  ...
}: {
  # Nix Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # NIX_PATH
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
    "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
    "nixos-hardware=${inputs.nixos-hardware}"
    "nur=${inputs.nur}"
    "home-manager=${inputs.home-manager}"
    "catppuccin=${inputs.catppuccin}"
    "zen-browser=${inputs.zen-browser}"
    "nix-jebrains-plugins=${inputs.nix-jebrains-plugins}"
    "blender-flake=${inputs.blender-flake}"
    "nix-flatpak=${inputs.nix-flatpak}"
  ];

  # Cachixes
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://nixpkgs-python.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # unstable overlay
  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs {
        config.allowUnfree = true;
        system = prev.system;
      };
      unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        system = prev.system;
      };
      bluez-5-75 = import inputs.nixpkgs-bluez-5-75 {
        config.allowUnfree = true;
        system = prev.system;
      };
    })

    # blender
    blender-flake.overlays.default
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 10";
  };

  # make devenv shut up
  nix.extraOptions = ''
    trusted-users = root itscrystalline
    builders-use-substitutes = true
  '';

  # remote buliders
  nix.buildMachines = [
    {
      hostName = "cwystaws-siwwybowox";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [];
      mandatoryFeatures = [];
    }
    {
      hostName = "cwystaws-grass-box";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [];
      mandatoryFeatures = [];
    }
  ];
  nix.distributedBuilds = true;

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
