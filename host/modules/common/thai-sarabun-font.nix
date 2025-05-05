{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "sipa-th-fonts";
  version = "1.0.0";

  src = pkgs.fetchzip {
    url = "https://oer.learn.in.th/search_detail/ZipDownload/220410";
    sha256 = "sha256-F1BWYueWPXESgKsuMIq0gZlJRDjQOJKcELatjWKJrYw=";
    extension = "zip";
    stripRoot = false;
  };

  buildPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp $src/Fonts/*.ttf $out/share/fonts/truetype
  '';
}
