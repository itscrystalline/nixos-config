{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "sipa-th-fonts";
  version = "1.0.0";

  src = pkgs.fetchzip {
    url = "https://www.kruploy.com/md/00100/3/13ThaiFont.zip";
    sha256 = "sha256-o/2yv9KuWcnqwXJtP9p437vaif+LFI++RWrNCB45aoY=";
    stripRoot = false;
  };

  buildPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp $src/Font/*.ttf $out/share/fonts/truetype
  '';
}
