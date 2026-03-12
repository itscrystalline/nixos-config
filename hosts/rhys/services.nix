{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    teamviewer.enable = true;
    logind.settings.Login.HandlePowerKey = "suspend";
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    sunshine = {
      package = pkgs.unstable.sunshine;
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  systemd.sleep.extraConfig = ''HibernateDelaySec=1h'';
}
