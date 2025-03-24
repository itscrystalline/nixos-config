{ config, pkgs, ... }@inputs:
{
  imports = [ ../common/services.nix ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [ gutenprint ];
    extraConf = ''
      DefaultPaperSize A4
    '';
  };

  services.hardware.argonone.enable = true;
  environment.etc = { 
    "argononed.conf".text = ''
      fans = 30, 50, 70, 100
      temps = 45, 55, 65, 70

      hysteresis = 5
    '';
  };
}


