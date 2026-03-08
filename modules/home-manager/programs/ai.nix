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
    home.shellAliases.opencode = "$SHELL -c 'source ${config.sops.secrets."oc-api-keys".path}; ${lib.getExe config.programs.opencode.package}'";

    programs = {
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        rules = ''
          When you need to search docs, use `context7` tools.
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
        };
      };
    };

    # xdg.configFile = "";
  };
}
