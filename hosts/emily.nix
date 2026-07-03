{pkgs, ...}: {
  imports = [./emily];

  core = {
    name = "emily";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFRCk/4nCN4kmfl4RYcs0PvC7dgGLBDbPFGomDDzbks itscrystalline@rhys"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOsWy7qHyVwh1EeddqFX2hWhsuIqVeObz1gyrQz5QGJR itscrystalline@mingzhu"
    ];

    fileSystems = {};
    stateVersion = "25.11";
    arch = "x86_64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  programs.enable = true;

  crystals-services = {
    ssh.enable = true;
    nginx.enable = true;
    docker.enable = true;
    tailscale = {
      enable = true;
      role = "server";
    };
    forgejo.runner = {
      enable = true;
      workers = 1;
    };

    pm.enable = true;
    pm.profile = "server";

    nix-binary-cache.ncro.publish = true;

    wakeonlan = {
      enable = true;
      interface = "enp9s0";
    };

    restartOnResumeServices = ["tailscaled" "gitea-runner-runner_x86_64_linux_emily_1"];
  };

  nix = {
    nh = {
      enable = true;
      dates = "weekly";
    };
    keepGenerations = 3;
    autoUpdate.enable = true;

    asBuilderConfig = {
      user = "nixremote";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONYz7Xr2Hyaf7kdruRJnvVsRfJ5rrkBMn8HTid79QvT nix-daemon@mingzhu"
      ];
      systems = ["x86_64-linux"];
      maxJobs = 4;
      speedFactor = 1;
    };
  };
  kernel = {
    package = pkgs.linuxPackages;
    cmdline = [
      "i915.enable_rc6=7"
      "i915.enable_fbc=1"
      "i915.lvds_downclock=1"
      "i915.powersave=1"

      "nouveau.modeset=0"
    ];

    sysctl = {
      "vm.swappiness" = 100;
      "vm.page-cluster" = 0;
    };
  };
  boot = {
    bootloader = "grub";
    verbosity = "verbose";
  };
}
