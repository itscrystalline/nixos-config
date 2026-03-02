{
  pkgs,
  config,
  lib,
  ...
}: let
  enabled = config.compat.nix-ld.enable;
in {
  options.compat.nix-ld.enable = lib.mkEnableOption "nix-ld w/ libs";
  config.programs.nix-ld = lib.mkIf enabled {
    enable = true;
    libraries = with pkgs; [
      zlib
      libz
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd

      libelf

      networkmanager
      coreutils
      pciutils
      nspr
      nss
      cups
      libcap
      libusb1
      dbus-glib
      ffmpeg
      libudev0-shim

      flac
      libimobiledevice
      libplist
    ];
  };
}
