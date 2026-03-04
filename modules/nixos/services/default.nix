{...}: {
  imports = [
    ./tailscale.nix
    ./ssh.nix
    ./earlyoom.nix
    ./avahi.nix
    ./docker.nix
    ./power-management.nix
    ./pipewire.nix
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
    ./ncps.nix
    ./iw2tryhard-dev.nix
    ./home-assistant.nix
    ./create-ap.nix
  ];
}
