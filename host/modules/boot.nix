{ config, pkgs, ... }@inputs:

{
  boot = {
    #plymouth
    plymouth = {
      enable = true;
      themePackages = [ (pkgs.plymouth-blahaj-theme.overrideAttrs (old: {
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
            cp ${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png watermark.png

            runHook postPatch
        '';
      })) ];
      theme = "blahaj";
    };

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
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
