{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.users.spinny;
in {
  options.crystal.users.spinny.enable = lib.mkEnableOption "spinny user configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    users.users.spinny = {
      isNormalUser = true;
      description = "spinny";
      shell = pkgs.bash;
    };
  };
}
