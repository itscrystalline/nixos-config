{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: {
  imports = [
    ../common/services.nix
    ../../services/adguardhome.nix
  ];

  adguard = {
    enable = true;
    rewriteList = {
      # "dorm.crys".answer = "100.125.37.13";
    };
  };

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.hardware.argonone.enable = true;
  environment.etc = {
    "argononed.conf".text = ''
      fans = 30, 60, 100
      temps = 45, 60, 70

      hysteresis = 5
    '';
  };

  services.home-assistant = with secrets.homeassistant; {
    enable = true;
    openFirewall = true;
    extraComponents = ["wiz" "matter"];
    config = {
      homeassistant = {
        name = "Dormitory";
        latitude = latitude;
        longitude = longitude;
      };
      http.server_port = 8000;
    };
    configWritable = true;
  };

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
