{
  lib,
  config,
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
    printers = lib.mkOption {
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
    defaultPrinter = lib.mkOption {
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
      extraConf = "DefaultPaperSize A4";
    };
    hardware.printers = lib.mkIf (printing.printers != []) ({
      ensurePrinters = printing.printers;
    } // lib.optionalAttrs (printing.defaultPrinter != null) {
      ensureDefaultPrinter = printing.defaultPrinter;
    });
    hardware.sane.enable = true;
    users.users.${config.core.primaryUser}.extraGroups = ["scanner" "lp"];
  };
}
