{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  nixos_logo = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nixos-white.svg";
    sha256 = "sha256-Ly4jHvtxlnOe1CsZ5+f+K7pclUF4S0HS4Vgs5U8Ofl4=";
  };
  generations = config.keep_generations;
  kernel = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;
in {
  system.modulesTree = [(lib.getOutput "modules" kernel.kernel)];
  boot = {
    # NTFS support
    supportedFilesystems = ["ntfs" "nfs"];

    # remote building from pi
    binfmt.emulatedSystems = ["aarch64-linux"];

    # CachyOS Kernel
    kernelPackages = kernel;
    kernel.sysctl."kernel.sysrq" = 1;

    #plymouth
    plymouth = {
      enable = true;
      themePackages = [
        (pkgs.plymouth-blahaj-theme.overrideAttrs (old: {
          patchPhase = ''
            runHook prePatch

            shopt -s extglob

            # deal with all the non ascii stuff
            mv !(*([[:graph:]])) blahaj.plymouth
            sed -i 's/\xc3\xa5/a/g' blahaj.plymouth
            sed -i 's/\xc3\x85/A/g' blahaj.plymouth

            # colors!
            sed -i 's/0x000000/0x11111b/g' blahaj.plymouth

            # watermark
            ${pkgs.inkscape}/bin/inkscape --export-height=48 --export-type=png --export-filename="watermark.png" ${nixos_logo}

            runHook postPatch
          '';
        }))
      ];
      theme = "blahaj";
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = generations;
        memtest86.enable = true;
        # extraEntries = {
        #   "macOS.conf" = ''
        #     title macOS (OpenCore)
        #     efi /efi/OC/OpenCore.efi
        #     sort-key macos
        #   '';
        # };
      };

      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
