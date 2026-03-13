{
  lib,
  pkgs,
  inputs,
  ...
}: let
  # evaluate our options
  eval = lib.evalModules {
    modules = [
      ./home-manager
      ./nixos
    ];
    specialArgs = {inherit pkgs inputs;};
  };
  # generate our docs
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (eval) options;
  };
in
  optionsDoc.optionsCommonMark
