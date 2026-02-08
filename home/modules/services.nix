{config, ...}: {
  # MPRIS Proxy (Bluetooth Audio)
  services.mpris-proxy.enable = config.gui;
}
