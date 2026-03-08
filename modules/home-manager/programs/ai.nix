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
          When you need to search docs, use `context7`'s tools.
          When you need to use the browser, use `playwright`'s tools.
          When you need to access github, use `github`'s tools.
          When you need to access nixpkgs, nixos options, home-manager options, nix-darwin, nixvim, the nixos wiki, nix.dev, flakehub, nix functions, the binary cache, use `nixos`'s tools.
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
          playwright = {
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
        sha256 = "sha256-GzNpraXV85qUwyGs5XDe0zHYr2AazqFppWtH9JvO3QE=";
        skills = ["pdf" "docx" "xlsx" "pptx"];
      }
      {
        repo = "tartinerlabs/skills";
        rev = "bf03b0bad773b49e7d547341a3e360d3f3a33b58";
        sha256 = "sha256-+TxwV95Ao8S7uIOTz6AolbSN0i0zdy9/NyxTNdVQvNU=";
        skills = ["github-actions"];
      }
      {
        repo = "knoopx/pi";
        rev = "702a7c6f6a78ed5a02b159e32c5ba057a3e13816";
        sha256 = "sha256-26eVdhSGrrhFfo8ncOEfxhZtS13XvevZY92gcjgQmjs=";
        skills = ["nix" "nix-flakes" "nh"];
      }
      {
        repo = "0xBigBoss/claude-code";
        rev = "c74dbed48e21f699ced5584a70a21133029f8556";
        sha256 = "sha256-YkeU+6SoeaGvLT1W1zJ60a1e0v2uoqoqCR0sY2vi84c=";
        skills = ["nix-best-practices"];
      }
      {
        repo = "julianobarbosa/claude-code-skills";
        rev = "865973f0f3f59df71c7075db2f1d424a82d9a147";
        sha256 = "sha256-L3jbc0tEk9oJuSRsx2/Nhe6JD6JgntKGCL90SMZ9maw=";
        skills = ["direnv"];
      }
    ];
  };
}
