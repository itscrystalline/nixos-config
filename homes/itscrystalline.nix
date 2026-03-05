{
  headless ? false,
  nextcloudMount ? false,
}: {lib, ...}: {
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
      };
      services.mpris-proxy.enable = true;
    })
  ];
}
