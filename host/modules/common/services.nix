{lib, ...}: {
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    # Tailscale VPN
    tailscale = {
      enable = true;
      extraSetFlags = ["--operator=itscrystalline"];
    };

    # IPP Printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      # nssmdns6 = true;
      openFirewall = true;
    };

    earlyoom = {
      enable = false;
      extraArgs = let
        catPatterns = patterns: lib.escapeShellArg "^(${builtins.concatStringsSep "|" patterns})$";
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
          "tailscaled"
          "argononed"
          "sshd"
          "systemd"
          "systemd-logind"
          "systemd-udevd"
          "tmux: client"
          "tmux: server"
        ];
      in [
        # "--prefer '^(${catPatterns preferPatterns})$'"
        "--avoid ${catPatterns avoidPatterns}"
      ];
    };
  };
}
