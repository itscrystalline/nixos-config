{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  inherit (config.hm) games;
  enabled = games.enable;
  guiEnabled = config.hm.gui.enable;
in {
  options.hm.games.enable = lib.mkEnableOption "games";

  config = lib.mkIf enabled (lib.mkIf guiEnabled {
    home.packages =
      (with pkgs; [
        (prismlauncher.override {
          additionalPrograms = [ffmpeg];
          gamemodeSupport = true;
          jdks = [
            graalvmPackages.graalvm-ce
            zulu8
            zulu21
          ];
        })
        itch
        mcpelauncher-ui-qt
      ])
      ++ lib.optionals (inputs ? my-nur) [
        inputs.my-nur.packages.${pkgs.hostsys}.irony-mod-manager
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        pkgs.bottles
      ];

    services.flatpak.packages = lib.optionals (pkgs.stdenv.isLinux && config.hm.flatpak.enable) [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
    ];
  });
}
