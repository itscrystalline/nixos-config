{ config, pkgs, nix-jebrains-plugins, ... }@inputs:
{
  imports = [ ./ides.nix ];

  home.packages = with pkgs; [
    devenv
    nixd
    gh
  ];

  # Devenv Cachix
  nix.settings = {
    substituters = [
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

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
