{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  inherit (config.hm.programs) ides;
  enabled = ides.enable;
  inherit (inputs) sanzenvim my-nur;
in {
  options.hm.programs.ides.enable = lib.mkEnableOption "IDEs and editors" // {default = true;};

  config = lib.mkIf enabled {
    home.packages = with pkgs;
      lib.optionals config.hm.gui.enable [
        arduino-ide
        neovide
        unityhub
      ]
      ++ (
        if (pkgs.stdenv.buildPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isAarch64)
        then lib.optionals (inputs ? sanzenvim) [sanzenvim.packages.${pkgs.hostsys}.defaultCross]
        else lib.optionals (inputs ? sanzenvim) [sanzenvim.packages.${pkgs.hostsys}.default]
      )
      ++ [
        gcc
        clang-tools
        alejandra
        prettierd
        stylua
        black
        rustfmt
        checkstyle
        google-java-format
        cpplint
        golangci-lint
        selene
        eslint_d
        shellcheck
        ktlint
        typescript-language-server
        vue-language-server
        yaml-language-server
        vscode-langservers-extracted
        verilator
        verible
        arduino-cli
        delta
      ]
      ++ lib.optionals (inputs ? my-nur) [
        my-nur.packages.${pkgs.hostsys}.veridian
      ];

    xdg.configFile = lib.mkIf config.hm.gui.enable {
      "neovide/config.toml".text = lib.optionalString (inputs ? sanzenvim) ''
        fork = true
        neovim-bin = "${sanzenvim.packages.${pkgs.hostsys}.default}/bin/nvim"

        [font]
        normal = ["JetBrainsMono Nerd Font", "Noto Sans CJK JP", "Noto Color Emoji"]
        size = 12
      '';
      "lazygit/config.yml".text = ''
        git:
          paging:
            colorArg: always
            pager: ${pkgs.delta}/bin/delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
      '';
    };

    programs.zed-editor = lib.mkIf config.hm.gui.enable {
      enable = false;
      package = pkgs.zed-editor.fhsWithPackages (p: with p; [zlib nil]);
      extensions = ["nix" "toml" "make" "git-firefly" "discord-presence"];
      userSettings = {
        assistant = {
          enabled = true;
          version = "2";
          default_open_ai_model = null;
          default_model = {
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };
        };
        buffer_font_family = lib.mkIf config.hm.theming.enable "JetBrainsMono Nerd Font";
        buffer_font_features.calt = true;
        hour_format = "hour24";
        auto_update = false;
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = false;
          dock = "bottom";
          detect_venv.on = {
            directories = [".env" "env" ".venv" "venv"];
            activate_script = "default";
          };
          env.TERM = "ghostty";
          font_family = lib.mkIf config.hm.theming.enable "JetBrainsMono Nerd Font";
          font_features = null;
          font_size = null;
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system";
          toolbar.title = true;
          working_directory = "current_project_directory";
        };
        lsp = {
          rust-analyzer.binary.path_lookup = true;
          nix.binary.path_lookup = true;
          php.binary.path_lookup = true;
          discord_presence.git_integration = true;
        };
        languages = {};
        load_direnv = "shell_hook";
        base_keymap = "JetBrains";
        theme.mode = "system";
        show_whitespaces = "all";
        ui_font_family = lib.mkIf config.hm.theming.enable "Inter Display";
        ui_font_size = 15;
        buffer_font_size = 15;
      };
    };
  };
}
