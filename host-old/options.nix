{lib, ...}: let
  inherit (lib) mkOption mkIf types;
in {
  options = {
    gui = {
      all = mkOption {
        type = types.bool;
        default = false;
      };
    };

    nix = {
      keep_generations = mkOption {
        type = types.int;
        default = 5;
      };
    };
  };
}
