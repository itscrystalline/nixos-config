{...}: {
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
  ];

  systemd = {
    settings.Manager.DefaultTimeoutStopSec = "20s";
    user.extraConfig = ''DefaultTimeoutStopSec=20s'';
  };
}
