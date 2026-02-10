{
  config,
  lib,
  ...
}: let
  cfg = config.crystal.raspi.docker;
in {
  options.crystal.raspi.docker.enable = lib.mkEnableOption "raspi docker configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        data-root = "/mnt/main/docker";
        dns = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];
      };
    };
  };
}
