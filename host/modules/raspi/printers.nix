{ ... }:
{
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_G2010_Series";
        location = "Home";
        deviceUri = "usb://Canon/G2010%20series?serial=0FEC28&interface=1";
        model = "gutenprint.5.3://bjc-G2000-series/expert";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Canon_G2010_Series";
  };
}
