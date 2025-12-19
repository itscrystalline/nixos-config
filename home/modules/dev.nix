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
    enable = true;
    settings = {
      user = {
        name = "itscrystalline";
        email = "pvpthadgaming@gmail.com";
      };
      safe.directory = "${config.home.homeDirectory}/nixos-config";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
