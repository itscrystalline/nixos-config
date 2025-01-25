{ config, pkgs, nix-jebrains-plugins, ... }@inputs:
{
  imports = [ ./ides.nix ];

  home.packages = with pkgs; [
    devenv
    nixd
    gh
    cargo-mommy

    filezilla
  ];

  programs.git = {
    userName  = "itscrystalline";
    userEmail = "pvpthadgaming@gmail.com";

    extraConfig = {
      safe = {
        directory = "/home/itscrystalline/nixos-config";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
