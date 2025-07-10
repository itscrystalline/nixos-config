{
  config,
  pkgs,
  ...
} @ inputs: {
  users.users.spinny = {
    isNormalUser = true;
    description = "spinny";
    shell = pkgs.bash;
  };
}
