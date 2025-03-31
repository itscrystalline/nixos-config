{config, ...}: let
  helpers = config.lib.nixvim;
in {
  imports = [
    ./neovide.nix
    ./keymaps.nix
    ./lsp.nix
  ];

  programs.nixvim = {
    enable = false;
    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.autoLoad = true;

    autoCmd = [
      {
        event = ["LspAttach"];
        callback = helpers.mkRaw ''
          function(args)
            -- 2
            vim.api.nvim_create_autocmd("BufWritePre", {
              -- 3
              buffer = args.buf,
              callback = function()
                -- 4 + 5
                vim.lsp.buf.format {async = false, id = args.data.client_id }
              end,
            })
          end
        '';
        group = "lsp";
      }
    ];
    autoGroups = {
      lsp = {
        clear = true;
      };
    };

    highlightOverride = {
      RainbowDelimiterRed.fg = "#f38ba8";
      RainbowDelimiterYellow.fg = "#f9e2af";
      RainbowDelimiterBlue.fg = "#89b4fa";
      RainbowDelimiterOrange.fg = "#fab387";
      RainbowDelimiterGreen.fg = "#a6e3a1";
      RainbowDelimiterViolet.fg = "#cba6f7";
      RainbowDelimiterCyan.fg = "#94e2d5";
    };

    opts.smartindent = true;

    extraConfigLua = ''

    '';
  };
}
