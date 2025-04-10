{...}: {
  services.rpcbind.enable = true;

  systemd.mounts = [
    rec {
      type = "nfs";
      what = "100.125.37.13:/export";
      where = "/mnt/nfs";
      mountConfig.Options = "noauto,_netdev,rsize=1048576,wsize=1048576,nconnect=8";
      unitConfig.TimeoutStopSec = "20s";
      unitConfig.TimeoutStartSec = "10s";
      upheldBy = ["tailscaled.service"];
      requires = ["network-online.target"];
      after = requires ++ upheldBy;
      bindsTo = upheldBy;
    }
  ];

  systemd.automounts = [
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/nfs";
    }
  ];
}
