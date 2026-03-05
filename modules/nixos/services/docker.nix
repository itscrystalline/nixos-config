{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.docker.enable;
in {
  options.crystals-services.docker.enable = lib.mkEnableOption "Docker";
  config = lib.mkIf enabled {
    users.users.${config.core.primaryUser}.extraGroups = ["docker"];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
    # k3d cpuset cgroup workaround https://github.com/NixOS/nixpkgs/issues/385044#issuecomment-2682670249
    systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
  };
}
