{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./ides.nix];

  home.packages = with pkgs;
    [
      gnumake
      unstable.devenv
      nixd
      gh
      cargo-mommy
      python3
    ]
    ++ pkgs.lib.optionals config.gui [
      filezilla
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      darwin.xcode
      mas
    ];

  programs.git = {
    userName = "itscrystalline";
    userEmail = "pvpthadgaming@gmail.com";

    extraConfig = {
      safe = {
        directory = "${config.home.homeDirectory}/nixos-config";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
