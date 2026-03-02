{config, ...}: {
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [config.core.primaryUser];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    polkit.enable = true;
  };

  users.users.${config.core.primaryUser}.extraGroups = ["wheel"];
}
