{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) sanzenvim my-nur;
  cfg = config.crystal.hm.ides;
  jetbrainsWayland = ''
    -Dawt.toolkit.name=WLToolkit
  '';
in {
  options.crystal.hm.ides.enable = lib.mkEnableOption "IDEs and editors" // {default = true;};
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
    lib.optionals config.gui [
      arduino-ide
      neovide
      unityhub
    ]
    ++ [
      sanzenvim.packages.${pkgs.hostsys}.default
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
      checkstyle
      shellcheck
      ktlint
      typescript-language-server
      vue-language-server
      yaml-language-server
      vscode-langservers-extracted
      verilator
      verible
      my-nur.packages.${pkgs.hostsys}.veridian

      arduino-cli
      delta
    ];

  xdg.configFile =
    lib.mkIf config.gui {
      "JetBrains/RustRover2024.3/rustrover64.vmoptions".text = jetbrainsWayland;
      "JetBrains/IntelliJIdea2024.3/idea64.vmoptions".text = jetbrainsWayland;
      "JetBrains/PyCharm2024.3/pycharm64.vmoptions".text = jetbrainsWayland;
      "JetBrains/WebStorm2024.3/webstorm64.vmoptions".text = jetbrainsWayland;
      "neovide/config.toml".text = ''
        fork = true
        neovim-bin = "${sanzenvim.packages.${pkgs.hostsys}.default}/bin/nvim"

        [font]
        normal = ["JetBrainsMono Nerd Font", "Noto Sans CJK JP", "Noto Color Emoji" ]
        size = 12
      '';
    }
    // {
      "lazygit/config.yml".text = ''
        git:
          paging:
            colorArg: always
            pager: ${pkgs.delta}/bin/delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
      '';
    };

  # programs.binary-ninja = lib.mkIf config.gui {
  #   enable = true;
  # };

  programs.zed-editor = lib.mkIf config.gui {
    enable = false;
    package = pkgs.zed-editor.fhsWithPackages (pkgs: with pkgs; [zlib nil]);
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
        shell = "hostsys";
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
        mode = "hostsys";
      };
      show_whitespaces = "all";
      ui_font_family = "Inter Display";
      ui_font_size = 15;
      buffer_font_size = 15;
    };
  };

  # programs.nvchad = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     # nixd
  #     nil
  #     alejandra
  #     vimPlugins.rustaceanvim
  #     vimPlugins.nvim-dap
  #     vimPlugins.nvim-dap-ui
  #     vimPlugins.rust-vim
  #     vimPlugins.crates-nvim
  #     vimPlugins.lazygit-nvim
  #     vimPlugins.telescope-zoxide
  #     vimPlugins.zoxide-vim
  #     vimPlugins.clangd_extensions-nvim
  #     vimPlugins.firenvim
  #     vimPlugins.nvim-jdtls
  #     php
  #     php82Packages.composer
  #     (python3.withPackages (ps:
  #       with ps; [
  #         python-lsp-server
  #         flake8
  #         pynvim
  #       ]))
  #     clang
  #     clang-tools
  #     lazygit
  #     delta
  #     rust-analyzer
  #     jdt-language-server
  #     vue-language-server
  #     typescript-language-server
  #     typescript
  #     vscode-langservers-extracted
  #     yaml-language-server
  #     taplo
  #     vscode-extensions.vscjava.vscode-gradle
  #     # pkgs.nodePackages."cssmodules-language-server"
  #     # pkgs.nodePackages."css-variables-language-server"
  #     lldb
  #     zoxide
  #   ];
  #   chadrcConfig = ''
  #     local M = {}
  #     M.base46 = {
  #       theme = "catppuccin",
  #     }
  #     return M
  #   '';
  #   extraConfig = ''
  #     require "nvchad.mappings"
  #
  #     vim.opt.smartindent = true
  #     vim.lsp.inlay_hint.enable(true)
  #
  #     --lsp
  #
  #     local lspconfig = require "lspconfig"
  #
  #     local servers = {"pylsp", "nil_ls", "clangd", "phpactor", "volar", "ts_ls", "cssls", "yamlls", "jsonls", "taplo", "jdtls", "gradle_ls"}
  #     local nvlsp = require "nvchad.configs.lspconfig"
  #
  #     for _, lsp in ipairs(servers) do
  #       local config = {
  #         on_attach = nvlsp.on_attach,
  #         on_init = nvlsp.on_init,
  #         capabilities = nvlsp.capabilities,
  #       }
  #       if lsp == "phpactor" then
  #         config["root_dir"] = function(_)
  #           return vim.loop.cwd()
  #         end
  #       end
  #       if lsp == "nil_ls" then
  #         config["settings"] = {
  #           ["nil"] = {
  #             formatting = {
  #               command = { "alejandra" },
  #             },
  #             nix = {
  #               flake = {
  #                 autoArchive = true,
  #                 -- autoEvalInputs = true,
  #               },
  #             },
  #           },
  #         }
  #       end
  #       if lsp == "ts_ls" then
  #         config["init_options"] = {
  #           plugins = {
  #             {
  #               name = "@vue/typescript-plugin",
  #               location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
  #               languages = {"javascript", "typescript", "vue"},
  #             },
  #           },
  #         }
  #         config["filetypes"] = {
  #           "javascript",
  #           "typescript",
  #           "vue",
  #         }
  #       end
  #       if lsp == "yamlls" then
  #         config["settings"] = {
  #           redhat = {
  #             telemetry = {
  #               enabled = false
  #             }
  #           },
  #           yaml = {
  #             schemas = {
  #               ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
  #               ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
  #             }
  #           }
  #         }
  #       end
  #       if lsp == "jdtls" then
  #         config["settings"] = {
  #           java = {
  #             eclipse = {
  #               downloadSources = true,
  #             },
  #             configuration = {
  #               updateBuildConfiguration = "automatic",
  #             },
  #             maven = {
  #               downloadSources = true,
  #             },
  #             implementationsCodeLens = {
  #               enabled = true,
  #             },
  #             referencesCodeLens = {
  #               enabled = true,
  #             },
  #             references = {
  #               includeDecompiledSources = true,
  #             },
  #             format = {
  #               enabled = true,
  #             },
  #           }
  #         }
  #       end
  #
  #       lspconfig[lsp].setup(config)
  #     end
  #
  #     -- format on save
  #     vim.api.nvim_create_autocmd("LspAttach", {
  #       group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  #       callback = function(args)
  #         -- 2
  #         vim.api.nvim_create_autocmd("BufWritePre", {
  #           -- 3
  #           buffer = args.buf,
  #           callback = function()
  #             -- 4 + 5
  #             vim.lsp.buf.format {async = false, id = args.data.client_id }
  #           end,
  #         })
  #       end
  #     })
  #
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f38ba8" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#f9e2af" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#89b4fa" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#fab387" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#a6e3a1" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#cba6f7" })
  #     vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#94e2d5" })
  #
  #     local map = vim.keymap.set
  #
  #     -- indents
  #     local n_opts = {silent = true, noremap = true}
  #     -- Visual mode
  #     map('v', '<', '<gv', n_opts)
  #     map('v', '>', '>gv', n_opts)
  #     -- Normal mode
  #     map('n', '<', '<<', n_opts)
  #     map('n', '>', '>>', n_opts)
  #
  #     -- arrow keys
  #     map('n', '<C-Left>', '<C-h>')
  #     map('n', '<C-Down>', '<C-j>')
  #     map('n', '<C-Up>', '<C-k>')
  #     map('n', '<C-Right>', '<C-l>')
  #
  #     -- alt+hjkl
  #     map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
  #     map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
  #     map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
  #     map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)
  #     map("n", "<A-Down>", ":m .+1<CR>==") -- move line up(n)
  #     map("n", "<A-Up>", ":m .-2<CR>==") -- move line down(n)
  #     map("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- move line up(v)
  #     map("v", "<A-Up>", ":m '<-2<CR>gv=gv") -- move line down(v)
  #
  #     -- inline hints
  #     map('n', "<Leader>l", "<cmd>lua if vim.lsp.inlay_hint.is_enabled() then vim.lsp.inlay_hint.enable(false, { bufnr }) else vim.lsp.inlay_hint.enable(true, { bufnr }) end<CR>", { desc = "Enable Inline Hints" })
  #
  #     -- Nvim DAP
  #     map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
  #     map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
  #     map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
  #     map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
  #     map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
  #
  #     map(
  #         "n",
  #         "<Leader>dd",
  #         "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  #         { desc = "Debugger set conditional breakpoint" }
  #        )
  #     map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
  #     map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
  #
  #     -- rustaceanvim
  #     map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
  #     map("n", "<Leader>rd", "<cmd>lua vim.cmd.RustLsp('openDocs')<CR>", { desc = "Rust: Open Documentation Under the cursor" })
  #     map("n", "<Leader>rD", "<cmd>lua vim.cmd.RustLsp('renderDiagnostic')<CR>", { desc = "Rust: Render diagnostics" })
  #     map("n", "<Leader>rc", "<cmd>lua vim.cmd.RustLsp('codeAction')<CR>", { desc = "Rust: Show code actions" })
  #
  #
  #     -- lazygit
  #     map("n", "<Leader>gg", "<cmd>LazyGit<CR>", { desc = "Open lazygit" })
  #
  #     --zoxide
  #     map("n", "<leader>cd", require("telescope").extensions.zoxide.list)
  #
  #     -- lsp
  #     map("n", "gd", '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { desc = "Go to Definition", silent = true, noremap = true })
  #     map("n", "gi", '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', { desc = "Go to Imglementation", silent = true, noremap = true })
  #     map("n", "gt", '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', { desc = "Go to Type Definition", silent = true, noremap = true })
  #     map("n", "gr", '<cmd>lua require("telescope.builtin").lsp_references()<CR>', { desc = "List References for this symbol", silent = true, noremap = true })
  #     map("n", "gs", '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', { desc = "List all symbols in buffer", silent = true, noremap = true })
  #
  #     map("n", "gS", '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', { desc = "List all symbols in buffer", silent = true, noremap = true })
  #     map("n", "<Leader>ra", "<cmd>Lspsaga lsp_rename ++project<CR>", { desc = "Rename Symbol", silent = true, noremap = true })
  #     map("n", "<Leader>cc", "<cmd>Lspsaga code_action<CR>", { desc = "Code actions", silent = true, noremap = true })
  #     map("n", "<C-]>", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition", silent = true, noremap = true })
  #     map("n", "<C-}>", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek Type Definition", silent = true, noremap = true })
  #
  #
  #     --neovide
  #     if vim.g.neovide then
  #       vim.keymap.set('v', '<C-c>', '"+y') -- Copy
  #       vim.keymap.set('n', '<C-v>', '"+P') -- Paste normal mode
  #       vim.keymap.set('v', '<C-v>', '"+P') -- Paste visual mode
  #       vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
  #       vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
  #
  #       vim.g.neovide_padding_top = 16
  #       vim.g.neovide_padding_bottom = 16
  #       vim.g.neovide_padding_right = 16
  #       vim.g.neovide_padding_left = 16
  #       vim.g.neovide_hide_mouse_when_typing = false
  #       vim.g.neovide_cursor_vfx_mode = "railgun"
  #       vim.g.neovide_cursor_animation_length = 0.1
  #     end
  #   '';
  #   extraPlugins = ''
  #     return {
  #       {
  #         "actionshrimp/direnv.nvim",
  #           lazy = false,
  #           opts = {
  #             type = "dir"
  #           }
  #       },
  #       {
  #         'mrcjkb/rustaceanvim',
  #         version = '^5', -- Recommended
  #           lazy = false, -- This plugin is already lazy
  #           ft = "rust",
  #         config = function ()
  #           local mason_registry = require('mason-registry')
  #           local codelldb = mason_registry.get_package("codelldb")
  #           local extension_path = codelldb:get_install_path() .. "/extension/"
  #           local codelldb_path = extension_path .. "adapter/codelldb"
  #           local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  #           local cfg = require('rustaceanvim.config')
  #
  #           vim.g.rustaceanvim = {
  #             dap = {
  #               adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  #             },
  #           }
  #         end
  #       },
  #       {
  #         'rust-lang/rust.vim',
  #         ft = "rust",
  #         init = function ()
  #           vim.g.rustfmt_autosave = 1
  #           end
  #       },
  #       {
  #         'hiphish/rainbow-delimiters.nvim',
  #         lazy = false,
  #         config = function ()
  #           vim.g.rainbow_delimiters = {
  #
  #             highlight = {
  #               'RainbowDelimiterRed',
  #               'RainbowDelimiterOrange',
  #               'RainbowDelimiterYellow',
  #               'RainbowDelimiterGreen',
  #               'RainbowDelimiterCyan',
  #               'RainbowDelimiterBlue',
  #               'RainbowDelimiterViolet',
  #             },
  #           }
  #         end
  #       },
  #       --{
  #       --  'nvimdev/lspsaga.nvim',
  #       --  event = 'LspAttach',
  #       --  config = function()
  #       --    require('lspsaga').setup({})
  #       --  end,
  #       --  dependencies = {
  #       --    'nvim-treesitter/nvim-treesitter', -- optional
  #       --    'nvim-tree/nvim-web-devicons',     -- optional
  #       --  }
  #       --},
  #       {
  #         "rachartier/tiny-code-action.nvim",
  #         dependencies = {
  #           {"nvim-lua/plenary.nvim"},
  #
  #           -- optional picker via telescope
  #           {"nvim-telescope/telescope.nvim"},
  #           -- optional picker via fzf-lua
  #           {"ibhagwan/fzf-lua"},
  #           -- .. or via snacks
  #           --{
  #           --  "folke/snacks.nvim",
  #           --  opts = {
  #           --    terminal = {},
  #           --  }
  #           --}
  #         },
  #         event = "LspAttach",
  #         opts = {
  #           backend = "delta",
  #           picker = "telescope",
  #         },
  #       },
  #       {
  #         'mfussenegger/nvim-jdtls',
  #         lazy = false,
  #       },
  #       {
  #         'mfussenegger/nvim-dap',
  #         config = function()
  #           local dap, dapui = require("dap"), require("dapui")
  #           dap.listeners.before.attach.dapui_config = function()
  #           dapui.open()
  #           end
  #           dap.listeners.before.launch.dapui_config = function()
  #           dapui.open()
  #           end
  #           dap.listeners.before.event_terminated.dapui_config = function()
  #           dapui.close()
  #           end
  #           dap.listeners.before.event_exited.dapui_config = function()
  #           dapui.close()
  #           end
  #
  #           dap.adapters.cppdbg = {
  #             id = 'cppdbg',
  #             type = 'executable',
  #             command = '/home/${config.username}/.local/share/nvim/mason/bin/OpenDebugAD7',
  #           }
  #         dap.configurations.rust = dap.configurations.cpp
  #           end,
  #       },
  #
  #       {
  #         'rcarriga/nvim-dap-ui',
  #         dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
  #         config = function()
  #           require("dapui").setup()
  #           end,
  #       },
  #
  #       {
  #         'saecki/crates.nvim',
  #         tag = 'stable',
  #         ft = {"toml"},
  #         config = function()
  #           require("crates").setup {
  #             completion = {
  #               cmp = {
  #                 enabled = true
  #               },
  #             },
  #           }
  #           require('cmp').setup.buffer({
  #             sources = { { name = "crates" }}
  #           })
  #         end
  #       },
  #       {
  #         'numirias/semshi'
  #       },
  #       {
  #         'p00f/clangd_extensions.nvim'
  #       },
  #       {
  #         "kdheepak/lazygit.nvim",
  #         lazy = false,
  #         cmd = {
  #           "LazyGit",
  #           "LazyGitConfig",
  #           "LazyGitCurrentFile",
  #           "LazyGitFilter",
  #           "LazyGitFilterCurrentFile",
  #         },
  #         -- optional for floating window border decoration
  #           dependencies = {
  #             "nvim-telescope/telescope.nvim",
  #             "nvim-lua/plenary.nvim",
  #           },
  #         config = function()
  #           require("telescope").load_extension("lazygit")
  #           end,
  #       },
  #       {
  #         "jvgrootveld/telescope-zoxide",
  #         lazy = false,
  #         dependencies = {
  #           "nvim-telescope/telescope.nvim",
  #           "nvim-lua/plenary.nvim",
  #           "nanotee/zoxide.vim",
  #         },
  #         config = function()
  #           require("telescope").load_extension('zoxide')
  #           end,
  #       },
  #       {
  #         "kylechui/nvim-surround",
  #         -- version = "*", -- Use for stability; omit to use `main` branch for the latest features
  #           event = "VeryLazy",
  #         config = function()
  #           require("nvim-surround").setup({
  #               -- Configuration here, or leave empty to use defaults
  #               })
  #         end
  #       },
  #       {
  #         "folke/todo-comments.nvim",
  #         dependencies = { "nvim-lua/plenary.nvim" },
  #         opts = {
  #           -- your configuration comes here
  #             -- or leave it empty to use the default settings
  #             -- refer to the configuration section below
  #         }
  #       },
  #       {
  #         'IogaMaster/neocord',
  #         event = "VeryLazy",
  #         enabled = not vim.g.started_by_firenvim,
  #         config = function()
  #           require("neocord").setup()
  #         end
  #       },
  #       {
  #         'glacambre/firenvim',
  #         lazy = false,
  #         build = ":call firenvim#install(0)",
  #         config = function()
  #           vim.g.firenvim_config = {
  #             localSettings = {
  #               ['https:\\/\\/labs\\.cognitiveclass\\.ai*'] = { selector = 'textarea:not([class=xterm-helper-textarea])' }
  #             }
  #           }
  #           if vim.g.started_by_firenvim then
  #             vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
  #               callback = function(e)
  #                 if vim.g.timer_started == true then
  #                   return
  #                 end
  #                 vim.g.timer_started = true
  #                 vim.fn.timer_start(3000, function()
  #                   vim.g.timer_started = false
  #                   vim.cmd('silent write')
  #                 end)
  #               end
  #             })
  #           end
  #         end
  #       }
  #     }
  #   '';
  # };
  };
}
