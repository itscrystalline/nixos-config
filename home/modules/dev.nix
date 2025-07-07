{
  config,
  pkgs,
  lib,
  nix-jebrains-plugins,
  ...
} @ inputs: {
  imports = [./ides.nix];

  home.packages = with pkgs;
    [
      unstable.devenv
      nixd
      gh
      cargo-mommy
      (python313Full.withPackages (p: [
        p.pyaudio
        p.aubio
      ]))
    ]
    ++ pkgs.lib.optionals config.gui [
      filezilla
      renode
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      darwin.xcode
      mas
    ];

  programs.git = {
    userName = config.username;
    userEmail = "pvpthadgaming@gmail.com";

    extraConfig = {
      safe = {
        directory = "/${
          if pkgs.stdenv.isDarwin
          then "Users"
          else "home"
        }/${config.username}/nixos-config";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
