{
  pkgs,
  lib,
  config,
  my-nur,
  ...
}: {
  # gnome polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkIf config.gui {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      After = ["graphical-session.target"];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # MPRIS Proxy (Bluetooth Audio)
  services.mpris-proxy.enable = config.gui;

  # vicinae server
  systemd.user.services.vicinae = lib.mkIf config.gui {
    Unit = {
      Description = "Vicinae launcher daemon";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${my-nur.packages.${pkgs.system}.vicinae}/bin/vicinae server";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
