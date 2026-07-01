{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.crystals-services.wakeonlan.enable;
  iface = config.crystals-services.wakeonlan.interface;
in {
  options.crystals-services.wakeonlan = {
    enable = lib.mkEnableOption "Wake-on-LAN for this host (needs hardware support)";
    interface = lib.mkOption {
      type = lib.types.str;
      description = "The interface to enable WOL on.";
      default = "";
    };
  };
  config = lib.mkIf enabled {
    networking.interfaces.${iface}.wakeOnLan.enable = true;
    network.ports.udp = [9];

    systemd.services.auto-suspend = {
      path = with pkgs; [coreutils bc];
      script = ''
        load=$(cat /proc/loadavg | cut -d' ' -f1)
        if (( $(echo "$load < 0.1" | bc -l) )); then
          systemctl suspend
        else
          echo $load
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
    systemd.timers.auto-suspend = {
      wantedBy = ["timers.target"];
      timerConfig.OnUnitActiveSec = "10m";
      timerConfig.Unit = "auto-suspend.service";
    };
  };
}
