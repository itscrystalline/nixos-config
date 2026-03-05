{
  lib,
  pkgs,
  ...
}: let
  # evaluate our options
  eval = lib.evalModules {
    modules = [
      ./home-manager
      ./nixos
    ];
    specialArgs = {inherit pkgs;};
  };
  # generate our docs
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (eval) options;
  };
in
  optionsDoc.optionsCommonMark
