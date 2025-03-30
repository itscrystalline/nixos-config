{
  config,
  pkgs,
  lib,
  ...
} @ inputs: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # IPP Printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # nssmdns6 = true;
    openFirewall = true;
  };

  services.earlyoom = {
    enable = true;
    extraArgs = let
      catPatterns = patterns: builtins.concatStringsSep "|" patterns;
      # preferPatterns = [
      #   ".firefox-wrappe"
      #   "hercules-ci-age"
      #   "ipfs"
      #   "java" # If it's written in java it's uninmportant enough it's ok to kill it
      #   ".jupyterhub-wra"
      #   "Logseq"
      # ];
      avoidPatterns = [
        "bash"
        "zsh"
        "mosh-server"
        "sshd"
        "systemd"
        "systemd-logind"
        "systemd-udevd"
        "tmux: client"
        "tmux: server"
      ];
    in [
      # "--prefer '^(${catPatterns preferPatterns})$'"
      "--avoid '^(${catPatterns avoidPatterns})$'"
    ];
  };
}
