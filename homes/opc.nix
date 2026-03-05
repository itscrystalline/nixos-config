{...}: {
  hm = {
    core.username = "opc";
    theming.enable = true;
    programs = {
      cli = {
        enable = true;
        dev.enable = true;
        fastfetch.profile = "minimal";
      };
      ides.enable = true;
    };
  };
}
