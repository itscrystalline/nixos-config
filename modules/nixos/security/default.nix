{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [doas-sudo-shim];

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [config.core.primaryUser];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    polkit.enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkIf config.gui.enable {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  users.users.${config.core.primaryUser}.extraGroups = ["wheel"];
}
