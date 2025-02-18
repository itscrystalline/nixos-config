{ pkgs, ... }:
{
  # steam-run and xhost (add and delete host names or user names to the list allowed to make connections to the X server)
  environment.systemPackages = [ pkgs.steam-run pkgs.xorg.xhost ];
  # nix-ld
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

      libadwaita
      libimobiledevice
      libplist
    ];
  };
}
