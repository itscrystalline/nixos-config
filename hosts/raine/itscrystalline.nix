{config, ...}: {
  users.users.${config.core.primaryUser}.extraGroups = ["docker" "scanner" "lp"];
}
