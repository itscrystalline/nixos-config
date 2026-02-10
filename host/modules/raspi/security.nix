{config, lib, secrets, ...}: let
  cfg = config.crystal.raspi.security;
in {
  imports = [../common/security.nix];

  options.crystal.raspi.security.enable = lib.mkEnableOption "raspi security configuration" // {default = true;};

  config = lib.mkIf cfg.enable {};
}
