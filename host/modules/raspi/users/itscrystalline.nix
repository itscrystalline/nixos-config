{...}: {
  imports = [../../common/users/itscrystalline.nix];

  users.users.itscrystalline.extraGroups = ["docker" "scanner" "lp"];
}
