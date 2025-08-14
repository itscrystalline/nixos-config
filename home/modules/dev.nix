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
      (python313.withPackages (p: [
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
