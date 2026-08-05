{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.programs) cli;
  enabled = cli.dev.ai.enable && cli.dev.enable && cli.enable;
  startScript = pkgs.writeShellScript "omp-with-secrets" ''
    set -a
    source ${config.sops.secrets.omp-api-keys.path}
    ${lib.getExe config.oh-my-pi.package} "$@"
  '';
in {
  options.hm.programs.cli.dev.ai.enable = lib.mkEnableOption "ai stuff";

  config = lib.mkIf enabled {
    home.shellAliases.omp = "${startScript}";

    sops.secrets."omp-api-keys" = {};
    oh-my-pi = {
      enable = true;
      settings = {
        theme = {
          dark = "dark-catppuccin";
          light = "light";
        };
        symbolPreset = "nerd";
        defaultThinkingLevel = "auto";
        ask.timeout = 0;
        tools.discoveryMode = "mcp-only";
        display.showTokenUsage = true;
        proseOnlyThinking = true;
        modelRoles = {
          default = "deepseek/deepseek-v4-pro:high";
          smol = "opencode-zen/deepseek-v4-flash-free";
          slow = "deepseek/deepseek-v4-pro:max";
          plan = "deepseek/deepseek-v4-flash:max";
          designer = "deepseek/deepseek-v4-flash:max";
          commit = "deepseek/deepseek-v4-flash:max";
          task = "deepseek/deepseek-v4-flash:max";
        };
        statusLine = {
          preset = "default";
          separator = "powerline-thin";
          sessionAccent = true;
        };
        memory.backend = "mnemopi";
        browser.headless = false;
        terminal = {
          showProgress = true;
          showImages = false;
        };
        tui.textSizing = false;
        tools.approvalMode = "write";
        error.notify = "on";
        bash.direnv = "auto";
        advisor.enabled = true;
      };

      skills = {
        pdf = "github:anthropics/skills/skills/pdf@b0cbd3df1533b396d281a6886d5132f623393a9c";
        docx = "github:anthropics/skills/skills/docx@b0cbd3df1533b396d281a6886d5132f623393a9c";
        xlsx = "github:anthropics/skills/skills/xlsx@b0cbd3df1533b396d281a6886d5132f623393a9c";
        pptx = "github:anthropics/skills/skills/pptx@b0cbd3df1533b396d281a6886d5132f623393a9c";
        frontend-design = "github:anthropics/skills/skills/frontend-design@b0cbd3df1533b396d281a6886d5132f623393a9c";

        github-actions = "github:tartinerlabs/skills/skills/github-actions@bf03b0bad773b49e7d547341a3e360d3f3a33b58";

        nix = "github:knoopx/pi/skills/nix@702a7c6f6a78ed5a02b159e32c5ba057a3e13816";
        nix-flakes = "github:knoopx/pi/skills/nix-flakes@702a7c6f6a78ed5a02b159e32c5ba057a3e13816";
        nh = "github:knoopx/pi/skills/nh@702a7c6f6a78ed5a02b159e32c5ba057a3e13816";

        direnv = "github:julianobarbosa/claude-code-skills/skills/direnv@ac701ada10169dc2a7008cb3f8279acdfb3846f5";
      };

      rules = {
        "no-sed-for-editing" = ''
          ---
          name: no-sed-for-editing
          description: "Use the edit tool instead of sed -i for file modifications"
          condition: "sed\\s+.*-i"
          scope: "tool:bash"
          ---

          Use the `edit` tool for file modifications, not `sed -i`. The edit tool handles line-anchored patches safely with snapshot tags and validates hunks. Plain `sed` without `-i` is fine for one-shot text inspection (e.g. `sed -n '/pattern/p'`). If a file is mangled beyond easy patching, rewrite it with `write`.
        '';
      };
      appendSystemPrompt = ''
        # speech
        talk like you're texting a smart friend who programs. casual, direct, no
        corporate speak. drop the formal structure when you don't need it — bullet
        points are fine but don't dress them up. contractions always. swear a little if
        it fits. girl speak !

        don't open with what you're about to do. just do it. don't close with a summary
        of what you just did. they can read.

        if something's wrong, just say it's wrong. if something's good, just say it's
        good. no "it's worth noting that" or "it's important to consider" — just say the
        thing.

        don’t say “honestly, “ its just filler imo
        bullet points are also filler, only use them where its appropriate. dont be like chatgpt

        she/they <3

        # software
        when you need a cli tool, first try just running it. if that isn't installed,
        don't try to install it permanently — use the `,` (comma) command instead.
        it's a nix-shell wrapper that runs any program from nixpkgs without installing it, e.g.:

          , arp -a
          , busybox ls
          , route -n

        just prefix the command with `,` and the package name (usually matches the
        binary name, but check nixpkgs if it doesn't resolve). never use apt/pip/npm
        global installs or touch system packages — `,` is the only way to pull in
        ad-hoc tools in this environment. but try to run just the command first, as the
        environment may already have it.
      '';

      mcp.mcpServers = {
        context7 = {
          type = "http";
          url = "https://mcp.context7.com/mcp";
          headers.Authorization = "Bearer \${CONTEXT7_API_KEY}";
        };
        github = {
          type = "stdio";
          command = "${lib.getExe pkgs.github-mcp-server}";
          args = ["stdio"];
          env.GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_PERSONAL_ACCESS_TOKEN}";
        };
        nixos = {
          type = "stdio";
          command = "${lib.getExe pkgs.mcp-nixos}";
        };
        devenv = {
          type = "stdio";
          command = "${lib.getExe pkgs.unstable.devenv}";
          args = ["mcp"];
        };
      };
    };
    home.file.".omp/agent/WATCHDOG.yml".text = ''
      advisors:
        - name: default
          model: opencode-zen/deepseek-v4-flash-free:high
          tools:
            - read
            - bash
            - glob
            - grep
            - lsp
            - inspect_image
            - recall
    '';
  };
}
