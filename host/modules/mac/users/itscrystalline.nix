{
  config,
  pkgs,
  ...
} @ inputs: {
  users.users.itscrystalline = {
    description = "itscrystalline";
    shell = pkgs.zsh;
  };
  system.primaryUser = "itscrystalline";
}
