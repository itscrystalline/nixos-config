{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) printing;
  enabled = printing.enable;
in {
  options.crystals-services.printing = {
    enable = lib.mkEnableOption "printing via CUPS";
    drivers = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Printer driver packages to install.";
      default = [];
    };
    openFirewall = lib.mkEnableOption "firewall port for CUPS";
    shared = lib.mkEnableOption "printer sharing over the network";
  };
  config = lib.mkIf enabled {
    services.printing = {
      enable = true;
      drivers = printing.drivers;
      openFirewall = printing.openFirewall;
      listenAddresses = lib.mkIf printing.shared ["*:631"];
      allowFrom = lib.mkIf printing.shared ["all"];
      browsing = printing.shared;
      defaultShared = printing.shared;
    };
  };
}
