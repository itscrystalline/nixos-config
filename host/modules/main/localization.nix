{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.desktop.localization;
in {
  imports = [../common/localization.nix];
  options.crystal.desktop.localization.enable = lib.mkEnableOption "desktop localization" // {default = true;};

  config = lib.mkIf cfg.enable {
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  };
}
