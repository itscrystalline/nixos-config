{ config, pkgs, nix-jebrains-plugins, ... }@inputs:
let
    pluginList = let
        plugins = nix-jebrains-plugins.plugins."${pkgs.system}".idea-ultimate."2024.3";
    in [
        plugins."com.github.catppuccin.jetbrains"
        plugins."com.github.catppuccin.jetbrains_icons"
        plugins."io.github.pandier.intellijdiscordrp"
        plugins."nix-idea"
        plugins."systems.fehn.intellijdirenv"
    ];
    jetbrainsWayland = ''
      -Dawt.toolkit.name=WLToolkit
    '';
in {
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate pluginList)
    (jetbrains.plugins.addPlugins unstable.jetbrains.rust-rover pluginList)
    (jetbrains.plugins.addPlugins unstable.jetbrains.pycharm-professional pluginList)
  ];

  xdg.configFile."JetBrains/RustRover2024.3/rustrover64.vmoptions".text = jetbrainsWayland;
  xdg.configFile."JetBrains/IntelliJIdea2024.3/idea64.vmoptions".text = jetbrainsWayland;
  xdg.configFile."JetBrains/PyCharm2024.3/pycharm64.vmoptions".text = jetbrainsWayland;

  programs.zed-editor = {
        enable = true;
        package = (pkgs.unstable.zed-editor.fhsWithPackages (pkgs: [ pkgs.zlib ]));
        extensions = ["nix" "toml" "make" "git-firefly" "discord-presence"];

        ## everything inside of these brackets are Zed options.
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

            hour_format = "hour24";
            auto_update = false;
            terminal = {
                alternate_scroll = "off";
                blinking = "off";
                copy_on_select = false;
                dock = "bottom";
                detect_venv = {
                    on = {
                        directories = [".env" "env" ".venv" "venv"];
                        activate_script = "default";
                    };
                };
                env = {
                    TERM = "ghostty";
                };
                font_family = "JetBrainsMono Nerd Font";
                font_features = null;
                font_size = null;
                line_height = "comfortable";
                option_as_meta = false;
                button = false;
                shell = "system";
                toolbar = {
                    title = true;
                };
                working_directory = "current_project_directory";
            };

            lsp = {
                rust-analyzer = {
                    binary = {
                        path_lookup = true;
                    };
                };
                nix = {
                    binary = {
                        path_lookup = true;
                    };
                };

                # discord presence
                discord_presence = {
                  git_integration = true;
                };
            };

            languages = {
            };

            ## tell zed to use direnv and direnv can use a flake.nix enviroment.
            load_direnv = "shell_hook";
            base_keymap = "JetBrains";
            theme = {
                mode = "system";
            };
            show_whitespaces = "all" ;
            ui_font_size = 15;
            buffer_font_size = 15;
        };
    };
}
