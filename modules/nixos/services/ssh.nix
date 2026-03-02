{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.ssh.enable;
in {
  options.crystals-services.ssh.enable = lib.mkEnableOption "SSH server";
  config.services.openssh = lib.mkIf enabled {
    enable = true;
    settings.SetEnv = "PATH=/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
  };
}
