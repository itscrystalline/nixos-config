_: {
  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    bluetooth.enable = true;
  };
  hardware.enableAllHardware = false;
}
