{
  lib,
  config,
  ...
}: {
  imports = [
    ./tailscale.nix
    ./ssh.nix
    ./earlyoom.nix
    ./avahi.nix
    ./docker.nix
    ./power-management.nix
    ./printing.nix
    ./argonone.nix
    ./nfs.nix
    ./scanservjs.nix
    ./nginx.nix
    ./blocky.nix
    ./cloudflared.nix
    ./nextcloud.nix
    ./monitoring.nix
    ./manga.nix
    ./nix-binary-cache.nix
    ./iw2tryhard-dev.nix
    ./home-assistant.nix
    ./create-ap.nix
    ./localsend.nix
    ./forgejo.nix
    ./stalwart.nix
    ./copyparty.nix
  ];

  options.crystals-services.essentialServices = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Essential systemd services to restart always.";
    default = [];
  };

  config.systemd = {
    settings.Manager.DefaultTimeoutStopSec = "20s";
    user.extraConfig = ''DefaultTimeoutStopSec=20s'';
    services = builtins.listToAttrs (map (name: {
        inherit name;
        value.serviceConfig.Restart = lib.mkForce "always";
      })
      config.crystals-services.essentialServices);
  };
}
