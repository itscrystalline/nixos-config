{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.programs.cli) dev;
  enabled = dev.enable && config.hm.programs.cli.enable;

  matlabScript = pkgs.writeShellScriptBin "matlab-web" ''
    TO_OPEN=''${1:-"$HOME/Documents/programming/00-Classes/signal-processing"}
    TO_OPEN=''$(readlink --canonicalize $TO_OPEN)
    docker run -d -p 8888:8888 --shm-size=512M -e MWI_MATLAB_STARTUP_SCRIPT="cd('$TO_OPEN')" -v "$TO_OPEN:$TO_OPEN" matlab-with-ls:latest -browser
    sleep 0.2
    xdg-open http://localhost:8888 &
  '';
in {
  imports = [./ai.nix];

  options.hm.programs.cli.dev.enable = lib.mkEnableOption "development tools";

  config = lib.mkIf enabled {
    home.packages = with pkgs;
      [
        gnumake
        unstable.devenv
        nixd
        cargo-mommy
        python3

        forgejo-cli

        matlabScript
      ]
      ++ lib.optionals config.hm.gui.enable [
        filezilla
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.xcode
        mas
      ];
    xdg.desktopEntries.MATLAB = {
      name = "MATLAB";
      exec = "${matlabScript}";
      terminal = false;
      type = "Application";
    };

    programs = {
      git = {
        enable = true;
        settings = {
          credential.helper = lib.mkBefore ["cache --timeout 216000"];
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
      };
      git-credential-oauth.enable = true;

      direnv = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
