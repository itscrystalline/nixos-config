{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.earlyoom.enable;
in {
  options.crystals-services.earlyoom.enable = lib.mkEnableOption "EarlyOOM";
  config.services.earlyoom = lib.mkIf enabled {
    enable = true;
    enableNotifications = true;
    extraArgs = let
      catPatterns = patterns: lib.escapeShellArg "^(${builtins.concatStringsSep "|" patterns})$";
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
      "--avoid ${catPatterns avoidPatterns}"
    ];
  };
}
