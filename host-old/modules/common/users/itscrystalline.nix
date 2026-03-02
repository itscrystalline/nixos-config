{
  config,
  lib,
  pkgs,
  secrets,
  ...
} @ inputs: let
  cfg = config.crystal.users.itscrystalline;
in {
  options.crystal.users.itscrystalline.enable = lib.mkEnableOption "user itscrystalline" // {default = true;};

  config = lib.mkIf cfg.enable {
    users.users.itscrystalline = {
      isNormalUser = true;
      home = lib.mkDefault "/home/itscrystalline";
      description = "itscrystalline";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;

      hashedPassword = secrets.crystal_password;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS4b7HxJiG6gAOvqw/fD5CKWP3HqOFdfi2zpwmPi4wu itscrystalline@cwystaws-meowchine"
      ];
    };
  };
}
