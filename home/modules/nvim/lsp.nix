{ ... }: {
  programs.nixvim = {
    lsp = {
      inlayHints = true;
    };
  };
}
