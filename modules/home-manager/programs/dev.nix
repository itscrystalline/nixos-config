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

  changeGitUserScript = pkgs.writeShellScriptBin "wararat-git" ''
    git config user.name "Wararat Choyrum"
    git config user.email "real@iw2tryhard.dev"
    git config user.signingkey "CF99E3DB703AF4F7"
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
        changeGitUserScript

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
          commit.gpgsign = true;
          user = {
            name = "itscrystalline";
            email = "crystal@iw2tryhard.dev";
            signingkey = "955937102112FE21";
          };
          safe.directory = "${config.home.homeDirectory}/nixos-config";
          pull.rebase = true;
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

      lazygit = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          services."git.iw2tryhard.dev" = "gitea:git.iw2tryhard.dev";
          git.pagers = [
            {
              colorArg = "always";
              pager = ''${pkgs.delta}/bin/delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
            }
          ];
          gui.theme = {
            activeBorderColor = lib.mkForce ["#f5c2e7" "bold"];
          };
        };
      };
    };
  };
}
