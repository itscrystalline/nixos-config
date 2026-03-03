## _module\.args

Additional arguments passed to each module in addition to ones
like ` lib `, ` config `,
and ` pkgs `, ` modulesPath `\.

This option is also available to all submodules\. Submodules do not
inherit args from their parent module, nor do they provide args to
their parent module or sibling submodules\. The sole exception to
this is the argument ` name ` which is provided by
parent modules to a submodule and contains the attribute name
the submodule is bound to, or a unique generated name if it is
not bound to an attribute\.

Some arguments are already passed by default, of which the
following *cannot* be changed with this option:

 - ` lib `: The nixpkgs library\.

 - ` config `: The results of all options after merging the values from all modules together\.

 - ` options `: The options declared in all modules\.

 - ` specialArgs `: The ` specialArgs ` argument passed to ` evalModules `\.

 - All attributes of ` specialArgs `
   
   Whereas option values can generally depend on other option values
   thanks to laziness, this does not apply to ` imports `, which
   must be computed statically before anything else\.
   
   For this reason, callers of the module system can provide ` specialArgs `
   which are available during import resolution\.
   
   For NixOS, ` specialArgs ` includes
   ` modulesPath `, which allows you to import
   extra modules from the nixpkgs package tree without having to
   somehow make the module aware of the location of the
   ` nixpkgs ` or NixOS directories\.
   
   ```
   { modulesPath, ... }: {
     imports = [
       (modulesPath + "/profiles/minimal.nix")
     ];
   }
   ```

For NixOS, the default value for this option includes at least this argument:

 - ` pkgs `: The nixpkgs package set according to
   the ` nixpkgs.pkgs ` option\.



*Type:*
lazy attribute set of raw value

*Declared by:*
 - [\<nixpkgs/lib/modules\.nix>](https://github.com/NixOS/nixpkgs/blob//lib/modules.nix)



## bluetooth\.enable



Whether to enable bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/bluetooth](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/bluetooth)



## boot\.bootloader



Boot loader\. ‘systemd-boot’ or ‘generic’\.



*Type:*
one of “systemd-boot”, “generic”

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## boot\.extraBootEntries



Additional boot entries for systemd-boot\. Does nothing on ‘generic’\.



*Type:*
attribute set



*Default:*
` { } `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## boot\.network



Whether to enable network in the initrd\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## boot\.stage1AvailableModules



Kernel modules available during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## boot\.stage1LoadedModules



Kernel modules loaded during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## boot\.verbosity



Boot logging verbosity\. Can be ‘silent’, ‘verbose’ or a plymouth package\.



*Type:*
one of “silent”, “verbose” or (submodule)



*Default:*
` "verbose" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/boot.nix)



## compat\.nix-ld\.enable



Whether to enable nix-ld w/ libs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/compatibility/nix-ld\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/compatibility/nix-ld.nix)



## compat\.steam-run\.enable



Whether to enable steam-run\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/compatibility/steam-run\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/compatibility/steam-run.nix)



## core\.arch



Architecture/Platform of the machine\.



*Type:*
string



*Default:*
` "x86_64-linux" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.fileSystems



Filesystems to configure in /etc/fstab\. Mirrors that of NixOS’s ow\.



*Type:*
attribute set

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.localization



The system’s localization settings\.



*Type:*
attribute set of (submodule)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.localization\.\<name>\.keymap



Console keymap\.



*Type:*
string



*Default:*
` "us" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.localization\.\<name>\.locale



System locale\.



*Type:*
string



*Default:*
` "ja_JP.UTF-8" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.localization\.\<name>\.timezone



Time zone\.



*Type:*
string



*Default:*
` "Asia/Bangkok" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.name



System name\.



*Type:*
string



*Default:*
` "localhost" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## core\.primaryUser



Main user’s username\.



*Type:*
string



*Default:*
` "itscrystalline" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos)



## crystal\.gui\.steam\.enable



Whether to enable steam\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/steam\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/steam.nix)



## crystal\.niri\.enable



Whether to enable niri \& friends\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/niri\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/niri.nix)



## crystals-services\.avahi\.enable



Whether to enable Avahi MDNS/SD\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/avahi\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/avahi.nix)



## crystals-services\.earlyoom\.enable



Whether to enable EarlyOOM\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/earlyoom\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/earlyoom.nix)



## crystals-services\.ssh\.enable



Whether to enable SSH server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/ssh\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/ssh.nix)



## crystals-services\.tailscale\.enable



Whether to enable Tailscale\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/tailscale\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/services/tailscale.nix)



## gui\.enable



Whether to enable GUI support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui)



## gui\.flatpak\.enable



Whether to enable flatpak\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/flatpak\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/flatpak.nix)



## gui\.graphics\.enable



Whether to enable graphics\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.enableSpecialisation



Whether to enable noDGPU specialisation\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.enable



Whether to enable NVIDIA PRIME\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.intelBusID



The Intel GPU’s bus ID\.



*Type:*
string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.nvidiaBusID



The NVIDIA GPU’s bus ID\.



*Type:*
string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/graphics.nix)



## gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/obs\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/gui/obs.nix)



## kernel\.package



Linux kernel package\.



*Type:*
package

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.cmdline



Linux kernel cmdline arguments\.



*Type:*
list of string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.emulatedArchitectures



Binfmt emulated architectures\.



*Type:*
list of string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.enable



Whether to enable hibernation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.device



Device to hibernate to\.



*Type:*
null or string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.modprobeConfig



Extra modprobe config\.



*Type:*
list of string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.moduleBlacklist



Kernel modules blacklisted\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2ModulePackages



Kernel modules available during stage 2\.



*Type:*
list of package

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2Modules



Kernel modules available during stage 2\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.supportedFilesystems



Supported Filesystems\.



*Type:*
list of string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## kernel\.sysctl



Linux kernel sysctl options\. Passed through to ` boot.kernel.sysctl `\.



*Type:*
attribute set

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/kernel/kernel.nix)



## network\.dhcp



Whether to enable DHCP\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## network\.mounts



List of Network mounts\.



*Type:*
list of (submodule)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.automount



To configure an automount for this mount point\.



*Type:*
boolean

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.mountPoint



Mount point on the local filesystem\.



*Type:*
string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.remote



Mount point source remote\.



*Type:*
string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.type



Mount point type\.



*Type:*
string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network/network-mounts.nix)



## network\.ports\.tcp



TCP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## network\.ports\.tcpRange



TCP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## network\.ports\.udp



UDP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## network\.ports\.udpRange



UDP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## network\.trustedInterfaces



Trusted Network Interfaces\.



*Type:*
list of string

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/network)



## nix\.keepGenerations



How many NixOS generations to keep\.



*Type:*
signed integer or floating point number



*Default:*
` 3 `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix)



## nix\.nh\.enable



Whether to enable nix-helper\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix)



## nix\.nh\.keepSince



NH option --keep-since, how long to keep lingering store paths for\.



*Type:*
string



*Default:*
` "1w" `



*Example:*
` "1w" `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/nix)



## programs\.enable



Whether to enable Programs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/programs](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/programs)



## theming\.enable



Whether to enable Theming using stylix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/theming](file:///nix/store/qjwiqvw9sryvblwkjymvdvx0hg25yhpy-source/modules/nixos/theming)


