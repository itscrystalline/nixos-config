{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.programs) cli;
  enabled = cli.dev.ai.enable && cli.dev.enable && cli.enable;
  startScript = pkgs.writeShellScript "opencode-with-secrets" ''
    set -a
    source ${config.sops.secrets."oc-api-keys".path}
    ${lib.getExe config.programs.opencode.package} "$@"
  '';
  mkSkills = list:
    lib.mergeAttrsList (map ({
      repo,
      rev,
      sha256,
      skills ? [],
    }: let
      src = pkgs.fetchgit {
        inherit rev sha256;
        url = "https://github.com/${repo}";
        sparseCheckout = map (e: "/skills/${e}") skills;
        nativeBuildInputs = [pkgs.openssh];
      };
    in
      builtins.listToAttrs (map (skill: {
          name = "opencode/skills/${skill}";
          value = {
            recursive = true;
            source = "${src}/skills/${skill}";
          };
        })
        skills))
    list);
in {
  options.hm.programs.cli.dev.ai.enable = lib.mkEnableOption "ai stuff";

  config = lib.mkIf enabled {
    home.shellAliases.opencode = "${startScript}";

    programs = {
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        rules = ''
            # Tool usage
            When you need to search docs, use `context7`'s tools.
            When you need to use the browser, use `playwright`'s tools.
            When you need to access github, use `github`'s tools.
            When you need to access nixpkgs, nixos options, home-manager options, nix-darwin, nixvim, the nixos wiki, nix.dev, flakehub, nix functions, the binary cache, use `nixos`'s tools.

            # Software
            Use nix to get software. use the `nixos` tool and the `nix-locate` command line tool to search for software, and use `nix run nixpkgs#.. nixpkgs#..`to run once, or `nix shell nixpkgs#..` to enter a shell with some software. Chances are that most software that you have skills for will not be available to you by default, so use your nix skill. for example, you can use nix run <installable> --command <actual command> -- <args> to run a command that isnt the same name as the installable.

            ## `nix run`
          nix run [option...] installable args...

          Note: this command's interface is based heavily around installables, which
          you may want to read about first (nix --help).

          Examples

            · Run the default app from the blender-bin flake:

                │ # nix run blender-bin

            · Run a non-default app from the blender-bin flake:

                │ # nix run blender-bin#blender_2_83

              Tip: you can find apps provided by this flake by running nix flake show
              blender-bin.

            · Run vim from the nixpkgs flake:

                │ # nix run nixpkgs#vim

              Note that vim (as of the time of writing of this page) is not an app
              but a package. Thus, Lix runs the eponymous file from the vim package.

            · Run vim with arguments:

                │ # nix run nixpkgs#vim -- --help

            Description

            nix run builds and runs installable, which must evaluate to an app or a
            regular Nix derivation.

            If installable evaluates to an app (see below), it executes the program
            specified by the app definition.

            If installable evaluates to a derivation, it will try to execute the
            program <out>/bin/<name>, where out is the primary output store path of the
            derivation, and name is the first of the following that exists:

              · The meta.mainProgram attribute of the derivation.
              · The pname attribute of the derivation.
              · The name part of the value of the name attribute of the derivation.

            For instance, if name is set to hello-1.10, nix run will run $out/bin/hello.

            ## `nix shell`
            nix shell [option...] installables...

            Note: this command's interface is based heavily around installables, which
            you may want to read about first (nix --help).

            Examples

              · Start a shell providing youtube-dl from the nixpkgs flake:

                  │ # nix shell nixpkgs#youtube-dl
                  │ # youtube-dl --version
                  │ 2020.11.01.1

              · Start a shell providing GNU Hello from NixOS 20.03:

                  │ # nix shell nixpkgs/nixos-20.03#hello

              · Run GNU Hello:

                  │ # nix shell nixpkgs#hello --command hello --greeting 'Hi everybody!'
                  │ Hi everybody!

              · Run multiple commands in a shell environment:

                  │ # nix shell nixpkgs#gnumake --command sh -c "cd src && make"

              · Run GNU Hello in a chroot store:

                  │ # nix shell --store ~/my-nix nixpkgs#hello --command hello

              · Start a shell providing GNU Hello in a chroot store:

                  │ # nix shell --store ~/my-nix nixpkgs#hello nixpkgs#bashInteractive --command >

                Note that it's necessary to specify bash explicitly because your
                default shell (e.g. /bin/bash) generally will not exist in the chroot.

            Description

            nix shell runs a command in an environment in which the $PATH variable
            provides the specified installables. If no command is specified, it starts
            the default shell of your user account specified by $SHELL.

            ## Python packages
            pip will almost always not work unless we are in a python venv. use `nix shell --impure --expr '(import <nixpkgs> {}).python3.withPackages (ps: with ps; [ your packages here ])'` to enter a shell with pip packages installed.
        '';
      };
      mcp = {
        enable = true;
        servers = {
          context7 = {
            url = "https://mcp.context7.com/mcp";
            headers = {
              CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
            };
            enabled = true;
          };
          playwright = lib.mkIf config.hm.gui.enable {
            command = "${lib.getExe pkgs.playwright-mcp}";
            enabled = true;
          };
          github = {
            command = "${lib.getExe pkgs.github-mcp-server}";
            args = ["stdio"];
            env.GITHUB_PERSONAL_ACCESS_TOKEN = config.secrets.ghToken;
            enabled = true;
          };
          nixos = {
            command = "${lib.getExe pkgs.mcp-nixos}";
            enabled = true;
          };
        };
      };
    };

    xdg.configFile = mkSkills [
      {
        repo = "anthropics/skills";
        rev = "b0cbd3df1533b396d281a6886d5132f623393a9c";
        sha256 = "sha256-KnrJRChOXETXB0GgoVqgXHoEOPT3QxR9MH3IL4FzmME=";
        skills = ["pdf" "docx" "xlsx" "pptx"];
      }
      {
        repo = "tartinerlabs/skills";
        rev = "bf03b0bad773b49e7d547341a3e360d3f3a33b58";
        sha256 = "sha256-GZdOV9OK2bhFXLdvSujxujOSODXoixLo1Wbc0mkvSwc=";
        skills = ["github-actions"];
      }
      {
        repo = "knoopx/pi";
        rev = "702a7c6f6a78ed5a02b159e32c5ba057a3e13816";
        sha256 = "sha256-fxGdhPwB9ePwlp4fhhCquNhLXnIZXHvKuObRGRUdRC8=";
        skills = ["nix" "nix-flakes" "nh"];
      }
      {
        repo = "julianobarbosa/claude-code-skills";
        rev = "865973f0f3f59df71c7075db2f1d424a82d9a147";
        sha256 = "sha256-ONvMhmryb4mIzJwk4b1UtE0z3JU/HoNwBJT0ZRjslLM=";
        skills = ["direnv"];
      }
    ];
  };
}
