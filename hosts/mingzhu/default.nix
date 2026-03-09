{...}: {
  imports = [./root.nix];

  services.logrotate.checkConfig = false;
  boot.tmp.cleanOnBoot = true;
  grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
}
