{
  config,
  pkgs,
  lib,
  ...
} @ inputs: {
  imports = [
    ./gui/blender.nix
  ];

  programs.chromium = lib.mkIf config.gui {
    enable = true;
    extensions = [
      "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
    ];
  };

  home.packages = lib.mkIf config.gui (
    with pkgs.stable;
      [
        vesktop # discor
        beeper # others
        keepassxc
        vlc
        # (ghostty.overrideAttrs (_: {
        #   preBuild = ''
        #     shopt -s globstar
        #     sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        #     shopt -u globstar
        #   '';
        # }))
        ghostty

        # video, audio, and image editing
        kdePackages.kdenlive
        gimp
        # FUCK YOU WHY ARE YOU SO BIG !!!!! I HAT EYOU!!!!
        # davinci-resolve
        audacity
        aseprite
        blockbench

        logisim-evolution
        wireshark
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        youtube-music
      ]
  );

  programs.obs-studio = lib.mkIf config.gui {
    enable = true;
    plugins = with pkgs.stable.obs-studio-plugins; [
      obs-composite-blur
      obs-backgroundremoval
    ];
  };

  programs.kitty = lib.mkIf config.gui {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
  };

  programs.fuzzel.enable = config.gui;
}
