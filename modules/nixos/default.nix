{lib, ...}: {
  imports = [./compatibility];

  options.core = {
    fileSystems = lib.mkOption {
      type = lib.types.attrs;
      description = "Filesystems to configure in /etc/fstab. Mirrors that of NixOS's ow.";
    };

    zram = lib.mkEnableOption "ZRAM swap";

    arch = lib.mkOption {
      type = lib.types.str;
      description = "Architecture/Platform of the machine.";
      default = "x86_64-linux";
    };
  };
}
