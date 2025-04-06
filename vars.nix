{lib, ...}: {
  options.gui = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  options.keep_generations = lib.mkOption {
    type = lib.types.int;
    default = 5;
  };
}
