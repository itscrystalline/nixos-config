{lib, ...}: {
  options.secrets = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
  };
  config.secrets = import ./secrets.nix;
  # config.secrets = import ./dummy.nix;
}
