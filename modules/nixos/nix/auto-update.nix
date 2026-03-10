{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.nix) autoUpdate;
  isRemote = autoUpdate.enable && autoUpdate.type == "remote";

  host = autoUpdate.remoteUpdaterHost;
  builder = lib.findFirst (b: b.hostName == host) null config.nix.remoteBuilders;
  sshKey =
    if builder != null
    then builder.sshKey
    else "/etc/nix/builder-key";
  sshUser =
    if builder != null
    then builder.user
    else "nixremote";
  hostname = config.networking.hostName;
  flakeAttr = "github:itscrystalline/nixos-config#nixosConfigurations.${hostname}.config.system.build.toplevel";
  sshRemote = "${pkgs.openssh}/bin/ssh -i ${sshKey} ${sshUser}@${host}";
  nix = "${config.nix.package.out}/bin/nix";
  nh = "${pkgs.nh}/bin/nh";
in {
  options.nix.autoUpdate = {
    enable = lib.mkEnableOption "automatic updates";
    type = lib.mkOption {
      type = lib.types.enum ["self" "remote"];
      default = "self";
      description = "Update type. 'self' means that the system will update itself, 'remote' means that it will request another host to build for it.";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "Mon *-*-* 12:00:00";
      description = "When automatic updates happen.";
    };

    remoteUpdaterHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Hostname to build the update on. Takes effect only if `type` is `remote`.";
    };
  };
  config = {
    system.autoUpgrade = lib.mkIf (autoUpdate.enable && autoUpdate.type == "self") {
      enable = true;
      persistent = true;
      flake = "github:itscrystalline/nixos-config";
      upgrade = false;
      runGarbageCollection = true;
    };

    systemd.timers.nixos-remote-upgrade = lib.mkIf isRemote {
      timerConfig.Persistent = true;
    };
    systemd.services.nixos-remote-upgrade = lib.mkIf isRemote {
      description = "NixOS Remote Upgrade";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      unitConfig.OnSuccess = "nix-gc.service";

      serviceConfig.Type = "oneshot";

      environment =
        config.nix.envVars
        // {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        };

      path = with pkgs; [
        coreutils
        gnutar
        xz.bin
        gzip
        gitMinimal
        config.nix.package.out
        config.programs.ssh.package
        nh
      ];

      script = ''
        set -euo pipefail

        echo "Building ${hostname} configuration on remote host ${host}..."
        outPath=$(${sshRemote} nix build --refresh --no-link --print-out-paths "${flakeAttr}")

        echo "Copying closure from ${host} to local store..."
        NIX_SSHOPTS="-i ${sshKey}" ${nix} copy --no-check-sigs --from ssh://${sshUser}@${host} "$outPath"

        echo "Activating new configuration..."
        ${nh} os switch --no-nom --bypass-root-check "$outPath"
      '';

      startAt = autoUpdate.dates;

      after = ["network-online.target"];
      wants = ["network-online.target"];
    };

    environment.systemPackages = lib.mkIf isRemote [
      (pkgs.writeShellScriptBin "remote-update" ''
        set -euo pipefail

        echo "Building ${hostname} configuration on remote host ${host}..."
        outPath=$(sudo ${sshRemote} nix build --refresh --no-link --print-out-paths "${flakeAttr}")

        echo "Copying closure from ${host} to local store..."
        NIX_SSHOPTS="-i ${sshKey}" sudo ${nix} copy --no-check-sigs --from ssh://${sshUser}@${host} "$outPath"

        echo "Activating new configuration..."
        ${nh} os switch --no-nom "$outPath"
      '')
    ];
  };
}
