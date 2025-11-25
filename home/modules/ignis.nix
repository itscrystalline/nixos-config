{
  pkgs,
  config,
  ...
}: {
  programs.ignis = {
    enable = config.gui;
    addToPythonEnv = true;
    services = {
      bluetooth.enable = true;
      recorder.enable = true;
      audio.enable = true;
      network.enable = true;
    };
    sass = {
      enable = true;
      useDartSass = true;
    };
    extraPackages = with pkgs; [
      matugen
      gpu-screen-recorder
      gnome-bluetooth
    ];
  };
}
