{ config, pkgs, zen-browser, blender-flake, ... }@inputs:
{
  imports = [
    ./gui/blender.nix
  ];

  # chromium with LINE extension
  programs.chromium = {
    enable = true;
    extensions = [
      "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
    ];
  };
  # desktop file
  xdg.desktopEntries.LINE = {
    name = "LINE";
    exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
    terminal = false;
    type = "Application";
    categories = [ "" ];
    mimeType = ["x-scheme-handler/org-protocol"];
  };

  home.packages = with pkgs.stable; [
    vesktop # discor
    teams-for-linux # teams :vomit:
    beeper # others
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

    # term emulators
    unstable.ghostty
    
    # cli that depend on gui
    copyq                                                                                                                                                    
    grim     
    hyprpicker                                                                                                                                               
    slurp                                                                                                                                                    
    wl-clipboard
    alsa-utils

    # video, audio, and image editing
    obs-studio
    kdenlive
    gimp
    davinci-resolve
    audacity
    aseprite
    blockbench
    figma-linux

    # wine
    wineWowPackages.waylandFull
    winetricks
  ] ++ [
    zen-browser.packages.${pkgs.system}.default
  ] ++ (with pkgs.unstable; [
    valent
  ]);
  
  programs.kitty = {
    enable = true;
    shellIntegration = {
      zsh = true;
    };
  };

  # Default Browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = (let browser = "zen.desktop"; in {
        "text/html" = browser;
        "text/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/vnd.mozilla.xul+xml" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
    });
  };
  home.sessionVariables.DEFAULT_BROWSER = "${zen-browser.packages.${pkgs.system}.default}/bin/qutebrowser";

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
  ];
}
