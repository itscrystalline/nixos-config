{...}: {
  imports = [./root.nix];

  services.logrotate.checkConfig = false;
  boot.tmp.cleanOnBoot = true;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
}
