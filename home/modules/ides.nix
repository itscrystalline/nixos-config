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

    idea_pluginList = let
        plugins = nix-jebrains-plugins.plugins."${pkgs.system}".idea-ultimate."2024.3";
    in [
        plugins."com.demonwav.minecraft-dev"
        plugins."com.github.tth05.minecraft-nbt-intellij-plugin"
    ];

    rustrover_pluginList = let
        plugins = nix-jebrains-plugins.plugins."${pkgs.system}".rust-rover."2024.3";
    in [
        plugins."PythonCore"
    ];


    jetbrainsWayland = ''
      -Dawt.toolkit.name=WLToolkit
    '';
in {
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins unstable.jetbrains.idea-ultimate (pluginList ++ idea_pluginList))
    (jetbrains.plugins.addPlugins unstable.jetbrains.rust-rover (pluginList ++ rustrover_pluginList))
    (jetbrains.plugins.addPlugins unstable.jetbrains.pycharm-professional pluginList)
    (jetbrains.plugins.addPlugins unstable.jetbrains.webstorm pluginList)
  ];

  xdg.configFile."JetBrains/RustRover2024.3/rustrover64.vmoptions".text = jetbrainsWayland;
  xdg.configFile."JetBrains/IntelliJIdea2024.3/idea64.vmoptions".text = jetbrainsWayland;
  xdg.configFile."JetBrains/PyCharm2024.3/pycharm64.vmoptions".text = jetbrainsWayland;
  xdg.configFile."JetBrains/WebStorm2024.3/webstorm64.vmoptions".text = jetbrainsWayland;

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

            buffer_font_family = "JetBrainsMono Nerd Font";
            buffer_font_features = {
              calt = true;
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
                php = {
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
            ui_font_family = "Inter Display";
            ui_font_size = 15;
            buffer_font_size = 15;
        };
    };

    programs.nvchad = {
      enable = true;
      extraPackages = with pkgs; [
            nixd
            vimPlugins.rustaceanvim
            vimPlugins.nvim-dap
            vimPlugins.nvim-dap-ui
            vimPlugins.rust-vim
            vimPlugins.crates-nvim
            (python3.withPackages(ps: with ps; [
              python-lsp-server
              flake8
            ]))
            rust-analyzer
            lldb
          ];
      chadrcConfig = ''
        local M = {}
        M.base46 = {
          theme = "catppuccin",
        }
        return M
      '';
      extraConfig = ''
        require "nvchad.mappings"

        local lspconfig = require "lspconfig"

        local servers = { "pylsp" }
        local nvlsp = require "nvchad.configs.lspconfig"

        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            on_attach = nvlsp.on_attach,
            on_init = nvlsp.on_init,
            capabilities = nvlsp.capabilities,
          }
        end

        local map = vim.keymap.set

        -- Nvim DAP
        map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
        map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
        map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
        map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
        map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
        map(
        	"n",
        	"<Leader>dd",
        	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        	{ desc = "Debugger set conditional breakpoint" }
        )
        map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
        map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

        -- rustaceanvim
        map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
      '';
      extraPlugins = ''
        return {
          {
                'mrcjkb/rustaceanvim',
                version = '^5', -- Recommended
                lazy = false, -- This plugin is already lazy
                ft = "rust",
                config = function ()
                local mason_registry = require('mason-registry')
                local codelldb = mason_registry.get_package("codelldb")
                local extension_path = codelldb:get_install_path() .. "/extension/"
                local codelldb_path = extension_path .. "adapter/codelldb"
                local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
                local cfg = require('rustaceanvim.config')

                vim.g.rustaceanvim = {
                    dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                    },
                }
                end
            },

            {
                'rust-lang/rust.vim',
                ft = "rust",
                init = function ()
                vim.g.rustfmt_autosave = 1
                end
            },

            {
                'mfussenegger/nvim-dap',
                config = function()
         			local dap, dapui = require("dap"), require("dapui")
                dap.listeners.before.attach.dapui_config = function()
                    dapui.open()
                end
                dap.listeners.before.launch.dapui_config = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated.dapui_config = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited.dapui_config = function()
                    dapui.close()
                end
          		end,
            },

            {
                'rcarriga/nvim-dap-ui',
                dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
                config = function()
         			require("dapui").setup()
          		end,
            },

            {
                'saecki/crates.nvim',
                ft = {"toml"},
                config = function()
                require("crates").setup {
                    completion = {
                    cmp = {
                        enabled = true
                    },
                    },
                }
                require('cmp').setup.buffer({
                    sources = { { name = "crates" }}
                })
                end
            },
            {
              'IogaMaster/neocord',
              event = "VeryLazy",
              config = function()
                require("neocord").setup()
              end
            }
        }
      '';
    };
  }
