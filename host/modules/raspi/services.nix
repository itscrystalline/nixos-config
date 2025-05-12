{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: let
  mkLocalNginx = name: port: alsoWs: {
    services.nginx.virtualHosts."${name}.crys".locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
      proxyWebsockets = alsoWs;
    };
  };
in {
  imports = [
    ../common/services.nix
    ../../services/adguardhome.nix
    ./docker.nix

    (inputs.nixpkgs-unstable + "/nixos/modules/services/hardware/scanservjs.nix")

    ./services/cloudflared.nix
    ./services/nextcloud.nix
    ./services/iw2tryhard-dev.nix
    (import ./services/grafana.nix {inherit config pkgs secrets mkLocalNginx;})
    (import ./services/manga.nix {inherit inputs config secrets mkLocalNginx;})

    (mkLocalNginx "scan" config.services.scanservjs.settings.port false)
    (mkLocalNginx "cock" config.services.cockpit.port false)
    (mkLocalNginx "dns" config.services.adguardhome.port false)
  ];

  adguard = {
    enable = true;
    rewriteList = {
      "dorm.crys".answer = "100.122.114.13";
      "*.crys".answer = "100.125.37.13";
    };
  };

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [gutenprint];
    extraConf = ''
      DefaultPaperSize A4
    '';
  };

  # REMOVE: once scanservjs gits into stable
  nixpkgs.overlays = [
    (final: prev: {
      scanservjs = pkgs.unstable.scanservjs;
    })
  ];
  services.scanservjs = {
    enable = true;
    settings.host = "0.0.0.0";
  };

  services.hardware.argonone.enable = true;
  environment.etc = {
    "argononed.conf".text = ''
      fans = 30, 60, 100
      temps = 45, 60, 70

      hysteresis = 5
    '';
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export 192.168.1.0/24(rw,sync,no_subtree_check) 100.0.0.0/8(rw,sync,no_subtree_check)
    '';
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
  };

  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
