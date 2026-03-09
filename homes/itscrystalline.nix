{
  minimal ? true,
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

      programs.cli.enable = true;
      programs.ssh.hosts = {
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
        mingzhu = {
          user = "itscrystalline";
          publicKeyPath = "${config.home.homeDirectory}/.ssh/mingzhu.pub";
          privateKeyPath = "${config.home.homeDirectory}/.ssh/mingzhu";
        };
      };

      services.nextcloud.enable = nextcloudMount;
    }
    (lib.mkIf (!minimal) {
      programs = {
        cli = {
          dev.enable = true;
          dev.ai.enable = true;
        };
        ides.enable = true;
      };
    })
    (lib.mkIf (!headless && !minimal) {
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
      };
      services.mpris-proxy.enable = true;
    })
  ];
}
