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
  services.blocky.settings.customDNS.mapping."git.iw2tryhard.dev" = "100.125.37.13";
}
