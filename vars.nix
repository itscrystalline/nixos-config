{lib, ...}: {
  options.gui = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
}
