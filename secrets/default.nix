{lib, ...}: let
  unlocked = builtins.pathExists ./unlocked;
  secrets =
    if unlocked
    then import ./secrets.nix
    else builtins.trace "WARNING: secrets.nix is locked (no secrets/unlocked sentinel), using dummy secrets." (import ./dummy.nix);
in {
  options.secrets = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
  };
  config = {inherit secrets;};
}
