{...}: {
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
        {name = "dap";}
        {name = "luasnip";}
        {name = "nvim_lua";}
      ];
    };

    direnv = {
      enable = true;
      autoLoad = true;
    };

    rustaceanvim = {
      enable = true;
    };
    crates = {
      enable = true;
    };

    rainbow-delimiters = {
      enable = true;
      highlight = [
        "RainbowDelimiterRed"
        "RainbowDelimiterOrange"
        "RainbowDelimiterYellow"
        "RainbowDelimiterGreen"
        "RainbowDelimiterCyan"
        "RainbowDelimiterBlue"
        "RainbowDelimiterViolet"
      ];
    };

    dap = {
      enable = true;
    };
    dap-ui = {
      enable = true;
    };
  };
}
