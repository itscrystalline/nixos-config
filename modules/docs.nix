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
  pkgs.stdenv.mkDerivation {
    src = ./.;
    name = "docs";
    nativeBuildInputs = with pkgs; [
      mkdocs
    ];
    buildPhase = ''
      mkdir -p docs
      ln -s ${optionsDoc.optionsCommonMark} "./docs/options.md"
      cat > mkdocs.yml <<EOF
      site_name: Crystal's Nix Module Options
      docs_dir: docs
      EOF
      mkdocs build
    '';
    installPhase = ''
      mv site $out
    '';
  }
