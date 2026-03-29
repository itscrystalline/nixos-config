{
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.network) mounts;

  enabled = builtins.length mounts > 0;

  systemdMounts =
    map (
      mount: rec {
        inherit (mount) type;
        what = mount.remote;
        where = mount.mountPoint;
        mountConfig.Options = "noauto,nofail,_netdev,rsize=1048576,wsize=1048576,nconnect=8";
        unitConfig.TimeoutStopSec = "20s";
        unitConfig.TimeoutStartSec = "10s";
        upheldBy = lib.optional config.crystals-services.tailscale.enable "tailscaled.service";
        requires = ["network-online.target"];
        wants = upheldBy;
        after = requires ++ upheldBy;
      }
    )
    mounts;
  systemdAutomounts =
    map ({mountPoint, ...}: {
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = mountPoint;
    })
    (builtins.filter (m: m.automount) mounts);
in {
  options.network.mounts = mkOption {
    type = types.listOf (types.submodule {
      options = {
        type = mkOption {
          type = types.str;
          description = "Mount point type.";
        };
        remote = mkOption {
          type = types.str;
          description = "Mount point source remote.";
        };
        mountPoint = mkOption {
          type = types.str;
          description = "Mount point on the local filesystem.";
        };
        automount = mkOption {
          type = types.bool;
          description = "To configure an automount for this mount point.";
        };
      };
    });
    description = "List of Network mounts.";
    default = [];
  };

  config = lib.mkIf enabled {
    services.rpcbind.enable = true;

    systemd.mounts = systemdMounts;
    systemd.automounts = systemdAutomounts;
  };
}
