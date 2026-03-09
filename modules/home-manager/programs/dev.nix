{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.programs.cli) dev;
  enabled = dev.enable && config.hm.programs.cli.enable;
in {
  imports = [./ai.nix];

  options.hm.programs.cli.dev.enable = lib.mkEnableOption "development tools" // {default = true;};

  config = lib.mkIf enabled {
    home.packages = with pkgs;
      [
        gnumake
        unstable.devenv
        nixd
        cargo-mommy
        python3
      ]
      ++ lib.optionals config.hm.gui.enable [
        filezilla
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.xcode
        mas
      ];

    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "itscrystalline";
            email = "pvpthadgaming@gmail.com";
          };
          safe.directory = "${config.home.homeDirectory}/nixos-config";
          pull.rebase = false;
        };
      };
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        hosts."github.com".user = "itscrystalline";
        settings.git_protocol = "https";
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
