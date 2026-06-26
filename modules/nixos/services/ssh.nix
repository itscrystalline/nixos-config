{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.ssh.enable;
  pwLogin = config.crystals-services.ssh.enablePasswordLogin;
in {
  options.crystals-services.ssh = {
    enable = lib.mkEnableOption "SSH server";
    enablePasswordLogin = lib.mkEnableOption "SSH password login";
  };
  config = lib.mkIf enabled {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = pwLogin;
        SetEnv = "PATH=/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      };
    };
    crystals-services.essentialServices = ["sshd"];
  };
}
