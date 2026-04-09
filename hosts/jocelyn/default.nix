_: {
  imports = [./disko.nix ./facter.nix];

  boot = {
    tmp.cleanOnBoot = true;
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  networking = {
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "103.99.11.104";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "103.99.11.1";
      interface = "ens18";
    };
    nameservers = ["8.8.8.8" "1.1.1.1"];
    search = ["readyidc.co"];
  };
}
