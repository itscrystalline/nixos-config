{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/services.nix
    ./docker.nix

    (inputs.nixpkgs-unstable + "/nixos/modules/services/hardware/scanservjs.nix")

    ./services/nextcloud.nix
    ./services/grafana.nix
  ];

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
      fans = 30, 50, 70, 100
      temps = 45, 55, 65, 70

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

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
