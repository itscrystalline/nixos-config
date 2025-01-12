{ config, pkgs, zen-browser, blender-flake, ... }@inputs:
{
  imports = [
    ./gui/blender.nix
  ];

  home.packages = with pkgs.stable; [
    vesktop # discor
    teams-for-linux # teams :vomit:
    (youtube-music.overrideAttrs (finalAttrs: previousAttrs: {
      desktopItems = [
          (makeDesktopItem {
            name = "youtube-music";
            exec = "youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
            icon = "youtube-music";
            desktopName = "Youtube Music";
            startupWMClass = "Youtube Music";
            categories = [ "AudioVideo" ];
          })
        ];
    })) # YT Music
    keepassxc
    teamviewer
    pavucontrol
    vlc
    gparted

    # video, audio, and image editing
    obs-studio
    kdenlive
    gimp
    davinci-resolve
    audacity
  ] ++ [
    zen-browser.packages.${pkgs.system}.default
  ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
  ];
}
