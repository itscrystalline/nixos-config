{
  lib,
  options,
  config,
  ...
}: {
  config = lib.optionalAttrs (options ? home-manager) {
    home-manager.extraSpecialArgs.passthrough = {
      gui.enable = config.gui.enable;
      bluetooth.enable = config.bluetooth.enable;
      niri.enable = config.gui.niri.enable;
    };
  };
}
