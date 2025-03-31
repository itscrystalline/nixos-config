{
  nv,
  helpers,
  ...
}: let
  mapKey = mode: key: action: options: {
    mode = mode;
    key = key;
    action = action;
    options = options;
  };
in {
  programs.nixvim = {
    keymaps = [
      (mapKey ["n"] ";" ":" {desc = "command mode shortcut";})

      # neovide keymaps
      (mapKey ["v"] "<C-c>" "\"+y") # Copy
      (mapKey ["n"] "<C-v>" "\"+P") # Paste normal mode
      (mapKey ["v"] "<C-v>" "\"+P") # Paste visual mode
      (mapKey ["c"] "<C-v>" "<C-R>+") # Paste command mode
      (mapKey ["i"] "<C-v>" "<ESC>l\"+Pli") # Paste insert mode
    ];

    globals.mapleader = " ";
  };
}
