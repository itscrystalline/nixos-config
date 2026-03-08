{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.programs) cli;
  enabled = cli.dev.ai.enable && cli.dev.enable && cli.enable;
  # mkSkills
in {
  options.hm.programs.cli.dev.ai.enable = lib.mkEnableOption "ai stuff";

  config = lib.mkIf enabled {
    home.shellAliases.opencode = "$SHELL -c 'set -a && source ${config.sops.secrets."oc-api-keys".path} && ${lib.getExe config.programs.opencode.package}'";

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

    # xdg.configFile = "";
  };
}
