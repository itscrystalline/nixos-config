{...}: {
  imports = [
    ./tailscale.nix
    ./ssh.nix
    ./earlyoom.nix
    ./avahi.nix
    ./docker.nix
    ./power-management.nix
    ./pipewire.nix
  ];
}
