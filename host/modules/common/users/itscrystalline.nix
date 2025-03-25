{
  config,
  pkgs,
  ...
} @ inputs: {
  users.users.itscrystalline = {
    isNormalUser = true;
    description = "itscrystalline";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}
