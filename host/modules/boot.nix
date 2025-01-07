{ config, pkgs, ... }@inputs:
{
  boot = {
    #plymouth
    plymouth = {
      enable = true;
      themePackages = [ (import ./plymouth-blahaj-theme.nix { inherit pkgs; }) ];
      theme = "blahaj";
    };

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
