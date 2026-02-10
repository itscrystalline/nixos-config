{
  config,
  lib,
  ...
}: let
  cfg = config.crystal.users.nixremote;
in {
  options.crystal.users.nixremote.enable = lib.mkEnableOption "nixremote user" // {default = true;};
  config = lib.mkIf cfg.enable {
    users.users.nixremote = {
      isNormalUser = true;
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo56BhzYI9rUdpbYMFF+BE0uI66xHolSInDkg3h4G7j root@cwystaws-raspi"
      ];
    };
  };
}
