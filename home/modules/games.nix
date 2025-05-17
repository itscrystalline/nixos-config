{
  config,
  pkgs,
  nur,
  lib,
  ...
}:
lib.mkIf config.gui {
  home.packages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ffmpeg];

      gamemodeSupport = true;

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu21
        nur.legacyPackages."${pkgs.system}".repos."7mind".graalvm-legacy-packages.graalvm17-ce
      ];
    })
    itch
  ];

  services.flatpak.packages = [
    {
      flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
      sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
    }
  ];
}
