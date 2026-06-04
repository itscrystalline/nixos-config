{lib, ...}: {
  imports = [./root.nix];

  boot.tmp.cleanOnBoot = true;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  services = {
    logrotate.checkConfig = false;
    oracle-cloud-agent.enable = true;
    ocid.enable = true;
  };

  services.blocky.settings.prometheus.enable = lib.mkForce true;
}
