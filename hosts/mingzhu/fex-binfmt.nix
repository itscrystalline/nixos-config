{pkgs, ...}: {
  # Register FEX as the binfmt handler for x86_64
  boot.binfmt.registrations."x86_64-linux" = {
    interpreter = "${pkgs.fex}/bin/FEX";
    magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
    mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    preserveArgvZero = true;
    openBinary = true;
    matchCredentials = true;
  };

  # Tell Nix this machine can build x86_64
  nix.settings.extra-platforms = ["x86_64-linux" "i686-linux"];

  # Expose FEX config and rootfs into the Nix sandbox
  nix.settings.sandbox-paths = [
    "/var/lib/fex-emu/RootFS/Ubuntu_24_04.sqsh"
    "/etc/fex-emu"
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/fex-emu 0755 root root -"
  ];

  system.activationScripts.fexRootFS = ''
    if [ ! -f /var/lib/fex-emu/RootFS/Ubuntu_24_04.sqsh ]; then
      HOME=/var/lib/fex-emu ${pkgs.fex}/bin/FEXRootFSFetcher --distro-name=ubuntu --distro-version=24.04 --assume-yes --as-is
      mv /var/lib/fex-emu/.fex-emu/* /var/lib/fex-emu/
      rm -r /var/lib/fex-emu/.fex-emu
    fi
  '';

  environment.etc."fex-emu/Config.json".text = builtins.toJSON {
    Config.RootFS = "/var/lib/fex-emu/RootFS/Ubuntu_24_04.sqsh";
    ThunksDB = {};
  };

  environment.systemPackages = with pkgs; [fex squashfsTools squashfuse];
}
