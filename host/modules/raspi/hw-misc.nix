{...}: {
  imports = [../common/hw-misc.nix];

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    bluetooth.enable = true;
  };
}
