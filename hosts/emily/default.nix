_: {
  imports = [./disko.nix ./facter.nix];
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  swapDevices = [
    {
      device = "/var/swap";
      size = 4096;
    }
  ];

  zramSwap.memoryPercent = 100;
}
