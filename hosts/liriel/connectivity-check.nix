{pkgs, ...}: {
  systemd = {
    services.connectivity-check = {
      description = "Check internet connectivity and restart services";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      path = with pkgs; [util-linux iputils coreutils-full];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${./connectivity-check.sh}";
        StandardOutput = "journal";
        StandardError = "journal";
        User = "root";
      };
    };

    timers.connectivity-check = {
      description = "Trigger connectivity check every 5 minutes";
      timerConfig = {
        OnBootSec = "30s";
        OnUnitActiveSec = "5m";
        Persistent = true;
      };
      wantedBy = ["timers.target"];
    };

    tmpfiles.rules = [
      "d /var/lib/connectivity-check 0755 root root -"
    ];
  };
}
