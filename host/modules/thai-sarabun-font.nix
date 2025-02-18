{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "sipa-th-fonts";
  version = "1.0.0";

  src = pkgs.fetchzip {
    url = "https://www.kruploy.com/md/00100/3/13ThaiFont.zip";
    sha256 = "1cyjq5zxwa5pgjsnx9v1c7ghnahi1cz53cpc69y3has2mgdabsr4";
    stripRoot = false;
  };

  buildPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp $src/Font/*.ttf $out/share/fonts/truetype 
  '';
}
