{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam-run ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # common requirement for several games
      stdenv.cc.cc.lib

      # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L72-L79
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva

      # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L124-L136
      fontconfig
      freetype
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libdrm
      libidn
      tbb
      zlib
    ];
  };
}
