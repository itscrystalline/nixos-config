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
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/bluetooth](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/bluetooth)



## boot\.bootloader



Boot loader\. ‘systemd-boot’ or ‘generic’\.



*Type:*
one of “systemd-boot”, “generic”

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## boot\.extraBootEntries



Additional boot entries for systemd-boot\. Does nothing on ‘generic’\.



*Type:*
attribute set



*Default:*
` { } `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## boot\.network



Whether to enable network in the initrd\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## boot\.stage1AvailableModules



Kernel modules available during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## boot\.stage1LoadedModules



Kernel modules loaded during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## boot\.verbosity



Boot logging verbosity\. Can be ‘silent’, ‘verbose’ or a plymouth package\.



*Type:*
one of “silent”, “verbose” or (submodule)



*Default:*
` "verbose" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/boot.nix)



## compat\.nix-ld\.enable



Whether to enable nix-ld w/ libs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/compatibility/nix-ld\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/compatibility/nix-ld.nix)



## compat\.steam-run\.enable



Whether to enable steam-run\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/compatibility/steam-run\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/compatibility/steam-run.nix)



## core\.arch



Architecture/Platform of the machine\.



*Type:*
string



*Default:*
` "x86_64-linux" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.fileSystems



Filesystems to configure in /etc/fstab\. Mirrors that of NixOS’s ow\.



*Type:*
attribute set

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.localization



The system’s localization settings\.



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.localization\.keymap



Console keymap\.



*Type:*
string



*Default:*
` "us" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.localization\.locale



System locale\.



*Type:*
string



*Default:*
` "ja_JP.UTF-8" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.localization\.timezone



Time zone\.



*Type:*
string



*Default:*
` "Asia/Bangkok" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.name



System name\.



*Type:*
string



*Default:*
` "localhost" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## core\.primaryUser



Main user’s username\.



*Type:*
string



*Default:*
` "itscrystalline" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos)



## crystals-services\.argonone\.enable



Whether to enable Argonone fan/power controller\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.fans



Fan speed percentages corresponding to each temperature threshold\.



*Type:*
list of signed integer



*Default:*

```
[
  30
  60
  100
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.hysteresis



Temperature hysteresis in °C before stepping down fan speed\.



*Type:*
signed integer



*Default:*
` 5 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.temps



Temperature thresholds in °C for fan speed steps\.



*Type:*
list of signed integer



*Default:*

```
[
  45
  60
  70
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/argonone.nix)



## crystals-services\.avahi\.enable



Whether to enable Avahi MDNS/SD\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/avahi\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/avahi.nix)



## crystals-services\.blocky\.enable



Whether to enable Blocky DNS server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.allowList



Custom allowlist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.denyList



Custom denylist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/blocky.nix)



## crystals-services\.cloudflared\.enable



Whether to enable Cloudflare tunnel\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/cloudflared\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/cloudflared.nix)



## crystals-services\.create-ap\.enable



Whether to enable create_ap WiFi hotspot\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks



List of static DHCP leases for the hotspot



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.hostname



Hostname\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.ip



IP address\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.lease



Lease time\.



*Type:*
string



*Default:*
` "infinite" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.mac



MAC address\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/create-ap.nix)



## crystals-services\.docker\.enable



Whether to enable Docker\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/docker\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/docker.nix)



## crystals-services\.earlyoom\.enable



Whether to enable EarlyOOM\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/earlyoom\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/earlyoom.nix)



## crystals-services\.home-assistant\.enable



Whether to enable Home Assistant\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/home-assistant\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/home-assistant.nix)



## crystals-services\.iw2tryhard-dev\.enable



Whether to enable personal website services\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/iw2tryhard-dev\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/iw2tryhard-dev.nix)



## crystals-services\.manga\.enable



Whether to enable Suwayomi manga server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/manga\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/manga.nix)



## crystals-services\.monitoring\.enable



Whether to enable Grafana + Prometheus + Loki + Promtail monitoring stack\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/monitoring\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/monitoring.nix)



## crystals-services\.ncps\.enable



Whether to enable ncps Nix cache proxy\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ncps\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ncps.nix)



## crystals-services\.ncps\.basePath



Base directory for ncps data, temp, and database files



*Type:*
string



*Default:*
` "/mnt/main/ncps" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ncps\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ncps.nix)



## crystals-services\.nextcloud\.enable



Whether to enable Nextcloud\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.adminpassFile



Path to a file containing the Nextcloud admin password\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.domain



Domain name for Nextcloud\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.folder



Main Nextcloud data directory\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.statsToken



Nextcloud serverinfo stats API token\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nfs\.enable



Whether to enable NFS server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.exports



Contents of /etc/exports\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.folder



Local directory to export via NFS (bind-mounted to /export)\.



*Type:*
string



*Default:*
` "/mnt/main/nfs" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nfs.nix)



## crystals-services\.nginx\.enable



Whether to enable Nginx reverse proxy\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nginx\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.localSuffix



suffix for local domains\.



*Type:*
string



*Default:*
` ".crys" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nginx\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/nginx.nix)



## crystals-services\.pipewire\.enable



Whether to enable PipeWire audio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/pipewire\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/pipewire.nix)



## crystals-services\.pm\.enable



Whether to enable Laptop power management\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/power-management\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/power-management.nix)



## crystals-services\.printing\.enable



Whether to enable printing via CUPS\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.defaultPrinter



Default printer name\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.drivers



Printer driver packages to install\.



*Type:*
list of package



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers



Printers to configure via CUPS\.



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.deviceUri



Printer device URI\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.location



Printer location\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.model



Printer PPD model\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.name



Printer name\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.ppdOptions



PPD options\.



*Type:*
attribute set of string



*Default:*
` { } `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.shared



Whether to enable printer sharing over the network\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/printing.nix)



## crystals-services\.scanservjs\.enable



Whether to enable scanservjs network scanner service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.scanservjs\.nginxVhost



Nginx virtual host name to proxy scanservjs under\. Null to disable\.



*Type:*
null or string



*Default:*
` "scan" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.ssh\.enable



Whether to enable SSH server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ssh\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/ssh.nix)



## crystals-services\.tailscale\.enable



Whether to enable Tailscale\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/tailscale\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/services/tailscale.nix)



## gui\.enable



Whether to enable GUI support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui)



## gui\.flatpak\.enable



Whether to enable flatpak\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/flatpak\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/flatpak.nix)



## gui\.graphics\.enable



Whether to enable graphics\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.enableSpecialisation



Whether to enable noDGPU specialisation\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.enable



Whether to enable NVIDIA PRIME\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.intelBusID



The Intel GPU’s bus ID\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.nvidiaBusID



The NVIDIA GPU’s bus ID\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/graphics.nix)



## gui\.niri\.enable



Whether to enable niri \& friends\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/niri\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/niri.nix)



## gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/obs\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/obs.nix)



## gui\.steam\.enable



Whether to enable steam\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/steam\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/gui/steam.nix)



## hardware\.raspberrypi\.enable



Whether to enable Raspberry Pi 4 hardware support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/hardware/raspberrypi\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/hardware/raspberrypi.nix)



## hm\.asBuilderConfig



When set, configures this HM user to act as a remote Nix builder
that other machines can offload builds to\.

An activation script manages the SSH authorized_keys entries\.
Note: system-level settings (trusted-users, system-features) must
still be configured out-of-band (e\.g\. /etc/nix/nix\.conf)\.

— BUILDER SETUP CHECKLIST —

 1. Set ` authorizedKeys ` to the builder keys of all client machines\.

 2. Ensure your user is trusted in /etc/nix/nix\.conf:
    trusted-users = root \<your-username>

 3. Make sure SSH is running and port 22 is reachable\.

 4. Give clients your host public key:
    cat /etc/ssh/ssh_host_ed25519_key\.pub



*Type:*
null or (submodule)



*Default:*
` null `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.asBuilderConfig\.authorizedKeys



SSH public keys of Nix clients permitted to use this machine
as a builder\. Each entry is the contents of the client’s
builder key (e\.g\. /etc/nix/builder-key\.pub)\.



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "ssh-ed25519 AAAA... nix-remote@client-host"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.asBuilderConfig\.maxJobs



Suggested maxJobs value for clients to use\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.asBuilderConfig\.speedFactor



Suggested speedFactor value for clients to use\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.asBuilderConfig\.systems



Systems this machine can natively build for\.



*Type:*
list of string



*Default:*

```
[
  "x86_64-linux"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.bluetooth\.enable



Whether to enable Bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager)



## hm\.core\.username



Username of this user\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager)



## hm\.flatpak\.enable



Whether to enable Flatpak support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/flatpak\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/flatpak.nix)



## hm\.gui\.enable



Whether to enable GUI configuration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager)



## hm\.gui\.niri\.enable



Whether to enable Niri window manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/niri\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/niri.nix)



## hm\.gui\.shell\.enable



Whether to enable Noctalia shell\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/shell\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/shell.nix)



## hm\.programs\.cli\.enable



Whether to enable CLI tools\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/cli\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.cli\.dev\.enable



Whether to enable development tools\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/dev\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/dev.nix)



## hm\.programs\.cli\.fastfetch\.profile



How much info fastfetch should produce\.



*Type:*
one of “full”, “minimal”



*Default:*
` "minimal" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/cli\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.games\.enable



Whether to enable games\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/games\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/games.nix)



## hm\.programs\.gui\.enable



Whether to enable GUI apps\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.largePrograms\.enable



Whether to enable Large GUI apps\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.vicinae\.enable



Whether to enable Vicinae launcher\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.own



List of vicinae plugins to install\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.raycast



List of vicinae-compatable raycast plugins to install\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.ides\.enable



Whether to enable IDEs and editors\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/ides\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/programs/ides.nix)



## hm\.remoteBuilders

List of remote Nix builders to offload builds to\.

— CLIENT SETUP CHECKLIST —

 1. Generate a key for Nix to use:
    ssh-keygen -t ed25519 -f /etc/nix/builder-key -N “” -C “nix-remote@\<this-host>”

 2. Add the public key to each builder’s ` hm.asBuilderConfig.authorizedKeys `\.

 3. Get each builder’s host public key for ` hostPublicKey `:
    ssh-keyscan \<builder-host> | grep ed25519

 4. Test:
    nix build --max-jobs 0 nixpkgs\#hello



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.hostName



Hostname or IP address of the remote builder\.
Must be reachable from this machine (LAN, Tailscale, etc\.)\.



*Type:*
string



*Example:*
` "builder.local" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.hostPublicKey



The SSH *host* public key of the remote builder\.
Added to known_hosts so Nix can connect without prompts\.

Find this by running on the builder:
cat /etc/ssh/ssh_host_ed25519_key\.pub



*Type:*
string



*Example:*
` "ssh-ed25519 AAAA..." `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.maxJobs



Maximum parallel builds to run on this builder\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.speedFactor



Relative speed hint; higher values are preferred\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.sshKey



Path to the *private* SSH key used to authenticate with the
remote builder\. Must be unencrypted (no passphrase)\.

Generate with:
ssh-keygen -t ed25519 -f /etc/nix/builder-key -N “” -C “nix-remote@$(hostname)”

The public half must be added to the builder’s authorized_keys
(via ` hm.asBuilderConfig.authorizedKeys ` on the builder side)\.



*Type:*
string



*Default:*
` "/etc/nix/builder-key" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.supportedFeatures



Features declared by this builder\.



*Type:*
list of string



*Default:*

```
[
  "nixos-test"
  "big-parallel"
  "kvm"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.systems



System types this builder can build for\.



*Type:*
list of string



*Default:*

```
[
  "x86_64-linux"
]
```



*Example:*

```
[
  "x86_64-linux"
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.remoteBuilders\.\*\.user



The user to SSH into on the remote builder\.
Must be trusted in the builder’s nix\.settings\.trusted-users\.



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/nix/remote-building.nix)



## hm\.services\.mpris-proxy\.enable



Whether to enable home MPRIS proxy\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/services/mpris\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/services/mpris.nix)



## hm\.services\.nextcloud\.enable



Whether to enable Nextcloud integration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/services/nextcloud\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/services/nextcloud.nix)



## hm\.theming\.enable



Whether to enable theming configuration\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/theming](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/home-manager/theming)



## kernel\.package



Linux kernel package (linuxPackages set)\.



*Type:*
raw value

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.cmdline



Linux kernel cmdline arguments\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.emulatedArchitectures



Binfmt emulated architectures\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.enable



Whether to enable hibernation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.device



Device to hibernate to\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.modprobeConfig



Extra modprobe config\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.moduleBlacklist



Kernel modules blacklisted\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2ModulePackages



Kernel module packages available during stage 2\.



*Type:*
list of package



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2Modules



Kernel modules available during stage 2\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.supportedFilesystems



Supported Filesystems\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## kernel\.sysctl



Linux kernel sysctl options\. Passed through to ` boot.kernel.sysctl `\.



*Type:*
attribute set



*Default:*
` { } `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/kernel/kernel.nix)



## network\.dhcp



Whether to enable DHCP\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## network\.mounts



List of Network mounts\.



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.automount



To configure an automount for this mount point\.



*Type:*
boolean

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.mountPoint



Mount point on the local filesystem\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.remote



Mount point source remote\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.type



Mount point type\.



*Type:*
string

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network/network-mounts.nix)



## network\.ports\.tcp



TCP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## network\.ports\.tcpRange



TCP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## network\.ports\.udp



UDP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## network\.ports\.udpRange



UDP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## network\.trustedInterfaces



Trusted Network Interfaces\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/network)



## nix\.asBuilderConfig



When set, configures this machine to act as a remote Nix builder
that other machines can offload builds to\.

This creates a dedicated system user, authorizes client SSH keys,
trusts the user with the Nix daemon, and optionally enables
binfmt emulation for cross-platform builds\.

— BUILDER SETUP CHECKLIST —

 1. Enable this option and set ` authorizedKeys ` to the public keys
    of all client machines’ daemon keys (/etc/nix/builder-key\.pub)\.

 2. Ensure ` crystals-services.ssh.enable = true ` is effective
    (this module sets it automatically)\.

 3. Make sure port 22 is reachable from client machines
    (check firewall/security group rules)\.

 4. After deploying, give clients your host public key:
    cat /etc/ssh/ssh_host_ed25519_key\.pub

 5. For cross-compilation, list target systems in ` emulatedSystems `
    and ensure the kernel has binfmt support\.



*Type:*
null or (submodule)



*Default:*
` null `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.authorizedKeys



SSH public keys of Nix daemons on client machines that are
permitted to use this machine as a builder\.

Each entry should be the contents of the client’s
/etc/nix/builder-key\.pub (the daemon key, NOT a user key)\.

Example entry:
“ssh-ed25519 AAAA… nix-daemon@client-host”



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "ssh-ed25519 AAAA... nix-daemon@my-laptop"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.emulatedSystems



Additional system types to support via binfmt emulation\.
Requires kernel binfmt support (enabled automatically via
` kernel.emulatedArchitectures `)\.

Use this to make an x86_64 machine build aarch64 packages,
for example\. Slower than native but avoids needing a separate
ARM builder\.



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "aarch64-linux"
  "armv7l-linux"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.maxJobs



Informational only on the server side — controls the hint
printed by the activation script\. The actual limit seen by
clients is set in their own ` remoteBuilders.*.maxJobs `\.
Set this to match the machine’s core count\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.speedFactor



Informational only on the server side — printed by the
activation script as a suggested value for clients to use
in their ` remoteBuilders.*.speedFactor `\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.systems



Systems this machine can natively build for\.
Defaults to the host’s own system type\.
Clients should list the same values in their ` remoteBuilders.*.systems `\.



*Type:*
list of string



*Default:*

```
[
  "x86_64-linux"
]
```



*Example:*

```
[
  "x86_64-linux"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.user



Name of the system user that remote clients SSH in as\.
This user is created automatically as a system user with
no login shell beyond what Nix needs\.
Must match the ` user ` field set on each client’s builder entry\.



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.keepGenerations



How many NixOS generations to keep\.



*Type:*
signed integer or floating point number



*Default:*
` 3 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix)



## nix\.nh\.enable



Whether to enable nix-helper\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix)



## nix\.nh\.keepSince



NH option --keep-since, how long to keep lingering store paths for\.



*Type:*
string



*Default:*
` "1w" `



*Example:*
` "1w" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix)



## nix\.remoteBuilders



List of remote Nix builders this machine should offload builds to\.
Setting any entries here automatically enables ` nix.distributedBuilds `
and configures SSH known hosts for each builder\.

— CLIENT SETUP CHECKLIST —

 1. Generate a daemon SSH key (once per client machine):
    ssh-keygen -t ed25519 -f /etc/nix/builder-key -N “” -C “nix-daemon@\<this-host>”

 2. Copy the public key to each builder’s authorizedKeys:
    On each builder, add the contents of /etc/nix/builder-key\.pub
    to ` nix.asBuilderConfig.authorizedKeys `\.

 3. Get each builder’s host public key for ` hostPublicKey `:
    ssh-keyscan \<builder-host> | grep ed25519

 4. Test the connection manually as root:
    sudo ssh -i /etc/nix/builder-key nixremote@\<builder-host> nix --version

 5. Trigger a test build:
    nix build --max-jobs 0 nixpkgs\#hello
    (max-jobs 0 forces all builds off-machine)



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostName



Hostname or IP address of the remote builder\.
Must be reachable by the local Nix daemon (which runs as root)\.
Can be a LAN hostname, a tailscale address, or a public IP\.



*Type:*
string



*Example:*
` "builder.local" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostPublicKey



The SSH *host* public key of the remote builder machine\.
This is added to the local known_hosts so the Nix daemon
can connect without interactive confirmation\.

Find this by running on the builder:
cat /etc/ssh/ssh_host_ed25519_key\.pub

Without this, the first build attempt will hang silently
waiting for a host key confirmation that never comes\.



*Type:*
string



*Example:*
` "ssh-ed25519 AAAA..." `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.maxJobs



Maximum number of builds to run in parallel on this builder\.
Should reflect the builder’s CPU core count\. The local daemon
will not schedule more than this many concurrent jobs to this machine\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.speedFactor



Relative speed hint used by the Nix daemon when choosing between
multiple available builders\. Higher values are preferred\.
A builder with speedFactor = 4 will be chosen over one with
speedFactor = 1, all else being equal\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.sshKey



Path to the *private* SSH key used by the local Nix daemon
to authenticate with the remote builder\.

IMPORTANT: This key must be:

 - Unencrypted (no passphrase) — the daemon cannot prompt for one
 - Readable by root (the daemon runs as root)
 - Generated separately from your personal SSH keys

Generate with:
ssh-keygen -t ed25519 -f /etc/nix/builder-key -N “” -C “nix-daemon@$(hostname)”

The public half (/etc/nix/builder-key\.pub) must be added to
the builder’s ` nix.asBuilderConfig.authorizedKeys `\.

If managing this key with agenix or sops-nix, ensure it is
decrypted and in place before the Nix daemon starts\.



*Type:*
string



*Default:*
` "/etc/nix/builder-key" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.supportedFeatures



Features the builder supports\. Derivations that require a feature
(e\.g\. ` requiredSystemFeatures = [ "kvm" ] `) will only be routed
to builders that declare that feature here\.

Common values:

 - “nixos-test”   — can run NixOS VM tests
 - “big-parallel” — has many cores, good for large parallel builds
 - “kvm”          — has KVM virtualisation available
 - “benchmark”    — stable environment suitable for benchmarking



*Type:*
list of string



*Default:*

```
[
  "nixos-test"
  "big-parallel"
  "kvm"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.systems



The system types this builder can build for\.
Must match what the builder actually supports — the Nix daemon
will only route derivations whose system matches this list\.

For cross-compilation support, the builder must have
` boot.binfmt.emulatedSystems ` configured (via ` emulatedSystems `
in ` asBuilderConfig ` on the builder side)\.



*Type:*
list of string



*Default:*

```
[
  "x86_64-linux"
]
```



*Example:*

```
[
  "x86_64-linux"
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.user



The user to SSH into on the remote builder\.
This user must exist on the builder and be listed in
its ` nix.settings.trusted-users `\.

The corresponding SSH key (see ` sshKey `) must be
authorized for this user on the builder side\.



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/nix/remote-building.nix)



## programs\.enable



Whether to enable Programs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/programs](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/programs)



## theming\.enable



Whether to enable Theming using stylix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/theming](file:///nix/store/0bb8zip68lmliyqqi4xqzdwp42nigan9-source/modules/nixos/theming)


