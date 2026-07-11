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
    ./wakeonlan.nix
    ./boinc.nix
  ];
  options.crystals-services = {
    essentialServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Essential systemd services to restart always.";
      default = [];
    };
    restartOnResumeServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Services that need restarting when the system resumes from sleep.";
      default = [];
    };
  };

  config.systemd = {
    settings.Manager.DefaultTimeoutStopSec = "20s";
    user.extraConfig = ''DefaultTimeoutStopSec=20s'';
    services = lib.mkMerge [
      (
        builtins.listToAttrs (map (name: {
            inherit name;
            value.serviceConfig.Restart = lib.mkForce "always";
          })
          config.crystals-services.essentialServices)
      )
      (lib.mkIf (config.crystals-services.restartOnResumeServices != []) (lib.mkMerge [
        {
          restart-on-resume = {
            description = "Restarts problematic services when the system resumes.";
            after = ["suspend.target"];
            wantedBy = ["suspend.target"];
            script = lib.concatLines (map (s: "systemctl --no-block restart ${s}") config.crystals-services.restartOnResumeServices);
            serviceConfig = {
              Type = "oneshot";
              StandardOutput = "journal";
              StandardError = "journal";
              User = "root";
            };
          };
        }
        (lib.mkIf config.nix.autoUpdate.enable (lib.mkMerge [
          (lib.mkIf (config.nix.autoUpdate.type == "self") {
            nixos-upgrade.after = ["restart-on-resume.service"];
          })
          (lib.mkIf (config.nix.autoUpdate.type == "remote") {
            nixos-remote-upgrade.after = ["restart-on-resume.service"];
          })
        ]))
      ]))
    ];
  };
}
