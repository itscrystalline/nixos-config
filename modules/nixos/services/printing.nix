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
    extraConf = lib.mkOption {
      type = lib.types.lines;
      description = "Extra CUPS configuration.";
      default = "";
    };
    sane = lib.mkEnableOption "SANE scanning support";
    ensurePrinters = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {type = lib.types.str; description = "Printer name.";};
          location = lib.mkOption {type = lib.types.str; description = "Printer location."; default = "";};
          deviceUri = lib.mkOption {type = lib.types.str; description = "Printer device URI.";};
          model = lib.mkOption {type = lib.types.str; description = "Printer PPD model.";};
          ppdOptions = lib.mkOption {type = lib.types.attrsOf lib.types.str; description = "PPD options."; default = {};};
        };
      });
      description = "Printers to configure via CUPS.";
      default = [];
    };
    ensureDefaultPrinter = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Default printer name.";
      default = null;
    };
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
      extraConf = printing.extraConf;
    };
    hardware.printers = lib.mkIf (printing.ensurePrinters != []) ({
      ensurePrinters = printing.ensurePrinters;
    } // lib.optionalAttrs (printing.ensureDefaultPrinter != null) {
      ensureDefaultPrinter = printing.ensureDefaultPrinter;
    });
    hardware.sane.enable = lib.mkIf printing.sane true;
  };
}
