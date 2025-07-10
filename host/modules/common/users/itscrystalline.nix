{
  lib,
  pkgs,
  secrets,
  ...
} @ inputs: {
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
}
