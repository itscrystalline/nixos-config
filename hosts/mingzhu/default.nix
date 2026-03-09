{...}: {
  imports = [./root.nix];

  services.logrotate.checkConfig = false;
  boot.tmp.cleanOnBoot = true;
}
