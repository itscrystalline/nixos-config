{
  inputs,
  pkgs-x86_64,
  pkgs-aarch64,
  ...
}: let
  docs' = pkgs: pkgs.callPackage ./modules/docs.nix {inherit inputs;};
  sanzenvim' = variant: pkgs: inputs.sanzenvim.packages.${pkgs.stdenv.hostPlatform.system}.${variant};

  sanzenvim-full' = sanzenvim' "default";
  sanzenvim-mini' = sanzenvim' "mini";
in {
  x86_64-linux = let
    pkgs = pkgs-x86_64;
  in {
    docs = docs' pkgs;

    xwayland-satellite-unstable = inputs.niri.packages.x86_64-linux.xwayland-satellite-unstable;
    steam = pkgs.steam.override {extraArgs = "-system-composer";};
    plymouth-blahaj-theme = pkgs.plymouth-blahaj-theme.overrideAttrs {
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
        cp ${./hosts/rhys/watermark.png} watermark.png

        runHook postPatch
      '';
    };
    prismlauncher = pkgs.prismlauncher.override (with pkgs; {
      additionalPrograms = [ffmpeg mangohud];
      gamemodeSupport = true;
      jdks = [
        graalvmPackages.graalvm-ce
        graalvmPackages.graalvm-oracle_17
        zulu8
        zulu17
        zulu21
        zulu25
      ];
    });
    blender = inputs.blender-flake.packages.x86_64-linux.default.overrideAttrs (_: _: let
      libs = with pkgs; [
        wayland
        libdecor
        libx11
        libxi
        libxxf86vm
        libxfixes
        libxrender
        libxkbcommon
        libGLU
        libglvnd
        numactl
        SDL2
        libdrm
        ocl-icd
        stdenv.cc.cc.lib
        openal
        libsm
        libice
        zlib
      ];
    in {
      installPhase = ''
        cd $out/libexec
        mv blender-* blender

        sed -i 's|^Exec=blender %f|Exec=env INTEL_DEBUG=reemit blender %f|' ./blender/blender.desktop

        mkdir -p $out/share/applications
        mv ./blender/blender.desktop $out/share/applications/blender.desktop

        mkdir $out/bin

        makeWrapper $out/libexec/blender/blender $out/bin/blender \
          --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${pkgs.lib.makeLibraryPath libs} \
          --prefix INTEL_DEBUG : reemit

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          blender/blender

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/libexec/blender/*/python/bin/python3*
      '';
    });
    pear-desktop = pkgs.pear-desktop.overrideAttrs {
      desktopItems = [
        (pkgs.makeDesktopItem {
          name = "pear-desktop";
          exec = "pear-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
          icon = "pear-desktop";
          desktopName = "Pear Desktop";
          startupWMClass = "Pear Desktop";
          categories = ["AudioVideo"];
        })
      ];
    };
    vesktop = pkgs.vesktop.overrideAttrs (_: prev: {
      patches =
        (prev.patches or [])
        ++ [
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/1251.patch";
            hash = "sha256-WmnXRISB1vfnbvSXJlD6sGkl5HSBTHpye+ezLyidtHU=";
          })
        ];
    });
    concord = inputs.concord.packages.x86_64-linux.concord;
    sanzenvim-full = sanzenvim-full' pkgs;
    sanzenvim-mini = sanzenvim-mini' pkgs;
  };
  aarch64-linux = let
    pkgs = pkgs-aarch64;
  in {
    docs = docs' pkgs;

    home-assistant = pkgs.unstable.home-assistant.overrideAttrs (_: {doInstallCheck = false;});
    copyparty = pkgs.copyparty.override {
      withFastThumbnails = true;
      withMagic = true;

      extraPackages = [pkgs.exiftool pkgs.cfssl];
    };
    create-ap = pkgs.linux-wifi-hotspot.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "lakinduakash";
        repo = "linux-wifi-hotspot";
        rev = "c0f153bff954542c5f0e551bfcad791f44ac345e";
        hash = "sha256-20yhcBhVlObl/aZKH4P2tdAeutTpZo+R0//i0/uAPFw=";
      };
    };
    sanzenvim-full = sanzenvim-full' pkgs;
    sanzenvim-mini = sanzenvim-mini' pkgs;
    linux_rpi4 = pkgs.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" {rpiVersion = 4;};
  };
}
