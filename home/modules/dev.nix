{
  config,
  pkgs,
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
    ]
    ++ pkgs.lib.optionals config.gui [
      filezilla
      renode
    ];

  programs.git = {
    userName = config.username;
    userEmail = "pvpthadgaming@gmail.com";

    extraConfig = {
      safe = {
        directory = "/home/${config.username}/nixos-config";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
