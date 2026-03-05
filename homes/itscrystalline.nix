{
  headless ? false,
  nextcloudMount ? false,
}: {
  lib,
  config,
  ...
}: {
  hm = lib.mkMerge [
    {
      core.username = "itscrystalline";
      theming.enable = true;

      programs = {
        cli = {
          enable = true;
          dev.enable = true;
        };
        ides.enable = true;
      };

      services.nextcloud.enable = nextcloudMount;
    }
    (lib.mkIf (!headless) {
      bluetooth.enable = true;
      flatpak.enable = true;
      gui = {
        enable = true;
        niri.enable = true;
        shell.enable = true;
      };
      programs = {
        gui = {
          enable = true;
          largePrograms.enable = true;
          vicinae = {
            enable = true;
            plugins = {
              own = ["wifi-commander" "nix" "it-tools" "niri" "bluetooth"];
              raycast = ["bintools" "github" "latex-math-symbols" "gif-search" "devdocs" "homeassistant" "wikipedia" "speedtest"];
            };
          };
        };
        games.enable = true;
        cli.fastfetch.profile = "full";

        ssh.hosts = {
          rhys = {
            user = "itscrystalline";
            publicKeyPath = "${config.home.homeDirectory}/.ssh/rhys.pub";
            privateKeyPath = "${config.home.homeDirectory}/.ssh/rhys";
          };
          liriel = {
            user = "itscrystalline";
            publicKeyPath = "${config.home.homeDirectory}/.ssh/liriel.pub";
            privateKeyPath = "${config.home.homeDirectory}/.ssh/liriel";
          };
          raine = {
            user = "itscrystalline";
            publicKeyPath = "${config.home.homeDirectory}/.ssh/raine.pub";
            privateKeyPath = "${config.home.homeDirectory}/.ssh/raine";
          };
          oracle-cloud = {
            hostname = "cwystaws-siwwybowox";
            user = "opc";
            publicKeyPath = "${config.home.homeDirectory}/.ssh/oracle_cloud.pub";
            privateKeyPath = "${config.home.homeDirectory}/.ssh/oracle_cloud";
          };
        };
      };
      services.mpris-proxy.enable = true;
    })
  ];
}
