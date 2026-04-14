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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/bluetooth](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/bluetooth)



## boot\.bootloader



Boot loader\. ‘limine’, ‘systemd-boot’, ‘grub’ or ‘generic’\.



*Type:*
one of “systemd-boot”, “generic”, “grub”, “limine”

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.extraBootEntries



Additional boot entries for systemd-boot/limine/grub\. Does nothing on ‘generic’\.



*Type:*
null or strings concatenated with “\\n” or (attribute set)



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.mountPoint



EFI mount point\.



*Type:*
string



*Default:*
` "/boot" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.network



Whether to enable network in the initrd\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.stage1AvailableModules



Kernel modules available during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.stage1LoadedModules



Kernel modules loaded during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## boot\.verbosity



Boot logging verbosity\. Can be ‘silent’, ‘verbose’ or a plymouth package\.



*Type:*
one of “silent”, “verbose” or (submodule)



*Default:*
` "verbose" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/boot.nix)



## compat\.nix-ld\.enable



Whether to enable nix-ld w/ libs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/compatibility/nix-ld\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/compatibility/nix-ld.nix)



## compat\.steam-run\.enable



Whether to enable steam-run\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/compatibility/steam-run\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/compatibility/steam-run.nix)



## core\.arch



Architecture/Platform of the machine\.



*Type:*
string



*Default:*
` "x86_64-linux" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.fileSystems



Filesystems to configure in /etc/fstab\. Mirrors that of NixOS’s\.



*Type:*
attribute set

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.localization



The system’s localization settings\.



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.localization\.keymap



Console keymap\.



*Type:*
string



*Default:*
` "us" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.localization\.locale



System locale\.



*Type:*
string



*Default:*
` "ja_JP.UTF-8" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.localization\.timezone



Time zone\.



*Type:*
string



*Default:*
` "Asia/Bangkok" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.name



System name\.



*Type:*
string



*Default:*
` "localhost" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.primaryUser



Main user’s username\.



*Type:*
string



*Default:*
` "itscrystalline" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.primaryUserSshKeys



SSH Keys allowed to log in to the ` primaryUser `\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## core\.stateVersion



NixOS State version\.



*Type:*
string



*Default:*
` "24.11" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos)



## crystals-services\.argonone\.enable



Whether to enable Argonone fan/power controller\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone.nix)



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.hysteresis



Temperature hysteresis in °C before stepping down fan speed\.



*Type:*
signed integer



*Default:*
` 5 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone.nix)



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/argonone.nix)



## crystals-services\.avahi\.enable



Whether to enable Avahi MDNS/SD\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/avahi\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/avahi.nix)



## crystals-services\.blocky\.enable



Whether to enable Blocky DNS server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.allowList



Custom allowlist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.customDNS



Custom DNS mappings of \<domain> to \<ip address>\. \<domain> is affixed with ` config.crystals-services.nginx.localSuffix `\.



*Type:*
attribute set of string



*Default:*
` { } `



*Example:*

```
{
  "" = "1.2.3.4";
  "test" = "5.6.7.8";
}

```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.denyList



Custom denylist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.listenAddress



Blocky’s listen IP address\. defaults to 0\.0\.0\.0 (all interfaces)\.



*Type:*
string



*Default:*
` "0.0.0.0" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/blocky.nix)



## crystals-services\.cloudflared\.enable



Whether to enable Cloudflare tunnel\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/cloudflared\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/cloudflared.nix)



## crystals-services\.cloudflared\.domains



Domains to open to the public via cloudflare tunnels



*Type:*
attribute set of (attribute set)



*Default:*
` { } `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/cloudflared\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/cloudflared.nix)



## crystals-services\.create-ap\.enable



Whether to enable create_ap WiFi hotspot\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks



List of static DHCP leases for the hotspot



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.hostname



Hostname\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.ip



IP address\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.lease



Lease time\.



*Type:*
string



*Default:*
` "infinite" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.mac



MAC address\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/create-ap.nix)



## crystals-services\.docker\.enable



Whether to enable Docker\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/docker\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/docker.nix)



## crystals-services\.earlyoom\.enable



Whether to enable EarlyOOM\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/earlyoom\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/earlyoom.nix)



## crystals-services\.forgejo\.enable



Whether to enable forgejo server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.directory



Forgejo’s state directory\.



*Type:*
string



*Default:*
` "/var/lib/forgejo" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.runner\.enable



Whether to enable forgejo actions runner\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.sync\.enable



Whether to enable syncing to github from forgejo\. requires importing the forgesync\.nixosModules\.default module\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/forgejo.nix)



## crystals-services\.home-assistant\.enable



Whether to enable Home Assistant\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/home-assistant\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/home-assistant.nix)



## crystals-services\.iw2tryhard-dev\.enable



Whether to enable personal website services\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/iw2tryhard-dev\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/iw2tryhard-dev.nix)



## crystals-services\.localsend\.enable



Whether to enable localsend\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/localsend\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/localsend.nix)



## crystals-services\.manga\.enable



Whether to enable Suwayomi manga server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/manga\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/manga.nix)



## crystals-services\.monitoring\.enable



Whether to enable Grafana + Prometheus + Loki + Promtail monitoring stack\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring.nix)



## crystals-services\.monitoring\.enableOpenTelemetryCollector



Whether to enable OpenTelemetry Collector\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring.nix)



## crystals-services\.monitoring\.additionalOpenTelemeteryResourceAttributes



Additional resource attributes to add to OpenTelemetry\.



*Type:*
list of (attribute set)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/monitoring.nix)



## crystals-services\.nextcloud\.enable



Whether to enable Nextcloud\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.adminpassFile



Path to a file containing the Nextcloud admin password\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.domain



Domain name for Nextcloud\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.folder



Main Nextcloud data directory\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.statsTokenFile



Path to a file containing the Nextcloud serverinfo stats API token\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nfs\.enable



Whether to enable NFS server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.exports



Contents of /etc/exports\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.folder



Local directory to export via NFS (bind-mounted to /export)\.



*Type:*
string



*Default:*
` "/mnt/main/nfs" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nfs.nix)



## crystals-services\.nginx\.enable



Whether to enable Nginx reverse proxy\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nginx\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.localSuffix



suffix for local domains\.



*Type:*
string



*Default:*
` "crys" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nginx\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nginx.nix)



## crystals-services\.nix-binary-cache\.enable



Whether to enable Local nix binary cache\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.basePath



Base directory for ncps’s data, temp, and database files



*Type:*
string



*Default:*
` "/var/lib/ncps" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.domain



local domain for all cache-related things\. this is affixed by ` config.crystals-services.nginx.localSuffix `\.



*Type:*
string



*Default:*
` "cache" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.nixCaches



Nix cache config for ncps to use\. ‘system’ means to use the global nix caches\.



*Type:*
one of “system”, \<set>



*Default:*

```
{
  publicKeys = [ ];
  urls = [ ];
}
```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.openTelemetryGrpcUrl



OpenTelemetry gRPC URL for sending logs and traces\. If null, telemetry is emitted to stdout\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.pm\.enable



Whether to enable Laptop power management\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/power-management\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/power-management.nix)



## crystals-services\.printing\.enable



Whether to enable printing via CUPS\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.defaultPrinter



Default printer name\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.drivers



Printer driver packages to install\.



*Type:*
list of package



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers



Printers to configure via CUPS\.



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.deviceUri



Printer device URI\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.location



Printer location\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.model



Printer PPD model\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.name



Printer name\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.ppdOptions



PPD options\.



*Type:*
attribute set of string



*Default:*
` { } `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.shared



Whether to enable printer sharing over the network\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/printing.nix)



## crystals-services\.scanservjs\.enable



Whether to enable scanservjs network scanner service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.scanservjs\.nginxVhost



Nginx virtual host name to proxy scanservjs under\. Null to disable\.



*Type:*
null or string



*Default:*
` "scan" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.ssh\.enable



Whether to enable SSH server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/ssh.nix)



## crystals-services\.stalwart\.enable



Whether to enable stalwart mail server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart.nix)



## crystals-services\.stalwart\.directory



Directory to store stalwart data



*Type:*
absolute path



*Default:*
` "/var/lib/stalwart-mail" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart.nix)



## crystals-services\.stalwart\.host



Main stalwart hostname\.



*Type:*
null or string



*Default:*
` "iw2tryhard.dev" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart.nix)



## crystals-services\.stalwart\.webUIHost



Nginx local host name to proxy stalwart web UI under\. Null to disable\.



*Type:*
null or string



*Default:*
` "stalwart.crys" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/stalwart.nix)



## crystals-services\.tailscale\.enable



Whether to enable Tailscale\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale.nix)



## crystals-services\.tailscale\.asExitNode



Whether to enable the use of this host as an exit node, only if ‘role’ is set to ‘server’…



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale.nix)



## crystals-services\.tailscale\.role



The tailscale role this host using\. This is to configure required options for tailscale’s features to work\. If set to ‘server’, this also configures the auth key\.



*Type:*
one of “client”, “server”



*Default:*
` "client" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/services/tailscale.nix)



## gui\.enable



Whether to enable GUI support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui)



## gui\.audio\.enable



Whether to enable PipeWire audio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/audio\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/audio.nix)



## gui\.flatpak\.enable



Whether to enable flatpak\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/flatpak\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/flatpak.nix)



## gui\.graphics\.enable



Whether to enable graphics\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.enableSpecialisation



Whether to enable noDGPU specialisation\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.enable



Whether to enable NVIDIA PRIME\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.intelBusID



The Intel GPU’s bus ID\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.nvidiaBusID



The NVIDIA GPU’s bus ID\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/graphics.nix)



## gui\.niri\.enable



Whether to enable niri \& friends (nixos)\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/niri\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/niri.nix)



## gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/obs\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/obs.nix)



## gui\.steam\.enable



Whether to enable steam\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/steam\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/gui/steam.nix)



## hardware\.raspberrypi\.enable



Whether to enable Raspberry Pi 4 hardware support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/hardware/raspberrypi\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/hardware/raspberrypi.nix)



## hm\.bluetooth\.enable

Whether to enable Bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager)



## hm\.core\.stateVersion



HM State version\.



*Type:*
string



*Default:*
` "24.11" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager)



## hm\.core\.username



Username of this user\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager)



## hm\.flatpak\.enable



Whether to enable Flatpak support\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/flatpak\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/flatpak.nix)



## hm\.gui\.enable



Whether to enable GUI configuration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui)



## hm\.gui\.niri\.enable



Whether to enable niri \& friends (home-manager)\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/niri\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/niri.nix)



## hm\.gui\.shell\.enable



Whether to enable Noctalia shell\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/shell\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/shell.nix)



## hm\.nix\.asBuilderConfig



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.authorizedKeys



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.maxJobs



Suggested maxJobs value for clients to use\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.speedFactor



Suggested speedFactor value for clients to use\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.systems



Systems this machine can natively build for\.



*Type:*
list of string



*Default:*

```
[
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders



List of remote Nix builders to offload builds to\.

— CLIENT SETUP CHECKLIST —

 1. Generate a key for Nix to use:
    ssh-keygen -t ed25519 -f /etc/nix/builder-key -N “” -C “nix-remote@\<this-host>”

 2. Add the public key to each builder’s ` hm.asBuilderConfig.authorizedKeys `\.

 3. Get each builder’s host public key for ` publicKeyPath `:
    ssh-keyscan \<builder-host> | grep ed25519

 4. Test:
    nix build --max-jobs 0 nixpkgs\#hello



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.hostName



Hostname or IP address of the remote builder\.
Must be reachable from this machine (LAN, Tailscale, etc\.)\.



*Type:*
string



*Example:*
` "builder.local" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.maxJobs



Maximum parallel builds to run on this builder\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.privateKeyPath



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.publicKeyPath



The SSH *host* public key of the remote builder\.
Written into ~/\.ssh/known_hosts and also used to set
StrictHostKeyChecking in the SSH match block for this builder\.

Find this by running on the builder:
cat /etc/ssh/ssh_host_ed25519_key\.pub



*Type:*
string



*Example:*
` "ssh-ed25519 AAAA..." `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.speedFactor



Relative speed hint; higher values are preferred\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.supportedFeatures



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.systems



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.user



The user to SSH into on the remote builder\.
Must be trusted in the builder’s nix\.settings\.trusted-users\.



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/nix/remote-building.nix)



## hm\.programs\.cli\.enable



Whether to enable CLI tools\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/cli\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.cli\.dev\.enable



Whether to enable development tools\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/dev\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/dev.nix)



## hm\.programs\.cli\.dev\.ai\.enable



Whether to enable ai stuff\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ai\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ai.nix)



## hm\.programs\.cli\.fastfetch\.profile



How much info fastfetch should produce\.



*Type:*
one of “full”, “minimal”



*Default:*
` "minimal" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/cli\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.games\.enable



Whether to enable games\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/games\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/games.nix)



## hm\.programs\.gui\.enable



Whether to enable GUI apps\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.largePrograms\.enable



Whether to enable Large GUI apps\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.vicinae\.enable



Whether to enable Vicinae launcher\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.own



List of vicinae plugins to install\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.raycast



List of vicinae-compatable raycast plugins to install\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.ides\.enable



Whether to enable IDEs and editors\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ides\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ides.nix)



## hm\.programs\.ssh\.authorizedKeys



Public key strings authorized to log into this user\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts



Hosts to configure SSH for\. Automatically adds them to matchBlocks and known_hosts\.



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.hostname



Hostname to connect to via SSH\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.privateKeyPath



Path to the private key on the host file system\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.publicKeyPath



Path to the public key on the host file system\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.user



User to connect to via SSH\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/programs/ssh.nix)



## hm\.services\.mpris-proxy\.enable



Whether to enable home MPRIS proxy\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/services/mpris\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/services/mpris.nix)



## hm\.services\.nextcloud\.enable



Whether to enable Nextcloud integration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/services/nextcloud\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/services/nextcloud.nix)



## hm\.theming\.enable



Whether to enable theming configuration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/theming](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/home-manager/theming)



## kernel\.package



Linux kernel package (linuxPackages set)\.



*Type:*
raw value

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.cmdline



Linux kernel cmdline arguments\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.emulatedArchitectures



Binfmt emulated architectures\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.enable



Whether to enable hibernation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.device



Device to hibernate to\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.modprobeConfig



Extra modprobe config\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.moduleBlacklist



Kernel modules blacklisted\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2ModulePackages



Kernel module packages available during stage 2\.



*Type:*
list of package



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2Modules



Kernel modules available during stage 2\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.supportedFilesystems



Supported Filesystems\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## kernel\.sysctl



Linux kernel sysctl options\. Passed through to ` boot.kernel.sysctl `\.



*Type:*
attribute set



*Default:*
` { } `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/kernel/kernel.nix)



## network\.dhcp



Whether to enable DHCP\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.mounts



List of Network mounts\.



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.automount



To configure an automount for this mount point\.



*Type:*
boolean

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.mountPoint



Mount point on the local filesystem\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.remote



Mount point source remote\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.type



Mount point type\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network/network-mounts.nix)



## network\.ports\.tcp



TCP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.ports\.tcpRange



TCP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.ports\.udp



UDP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.ports\.udpRange



UDP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.profiles



NetworkManager profiles automatically configured via known-networks or inline attrsets\.



*Type:*
list of (string or (attribute set))



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.trustedInterfaces



Trusted Network Interfaces\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## network\.unmanagedInterfaces



Network interfaces that NetworkManager will not manage\.



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "end0"
]
```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/network)



## nix\.asBuilderConfig



Configure this machine as a remote builder\.



*Type:*
null or (submodule)



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.authorizedKeys



SSH public keys of machines allowed to use this builder



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.emulatedSystems



Extra systems to support via binfmt emulation (e\.g\. aarch64-linux)



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.maxJobs



Max parallel build jobs to accept



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.speedFactor



Relative speed hint for client scheduling (higher = preferred)



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.systems



Systems this machine can build for



*Type:*
list of string



*Default:*

```
[
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.user



User that clients SSH in as to perform builds



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.autoUpdate\.enable



Whether to enable automatic updates\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.dates



When automatic updates happen\. The default is at 6PM local time\.



*Type:*
string



*Default:*
` "*-*-* 18:00:00" `



*Example:*
` *-1..12/3-1..31/2 00:30:00 ` => half past midnight on every other day on every 3rd month\.

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.remoteUpdaterHost



Hostname to build the update on\. Takes effect only if ` type ` is ` remote `\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.type



Update type\. ‘self’ means that the system will update itself, ‘remote’ means that it will request another host to build for it\.



*Type:*
one of “self”, “remote”



*Default:*
` "self" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/auto-update.nix)



## nix\.keepGenerations



How many NixOS generations to keep\.



*Type:*
signed integer or floating point number



*Default:*
` 3 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix)



## nix\.nh\.enable



Whether to enable nix-helper\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix)



## nix\.nh\.dates



How often to run ` nh clean `\. systemd timer format\.



*Type:*
string



*Default:*
` "weekly" `



*Example:*
` "weekly" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix)



## nix\.nh\.keepSince



NH option --keep-since, how long to keep lingering store paths for\.



*Type:*
string



*Default:*
` "1w" `



*Example:*
` "1w" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix)



## nix\.remoteBuilders



Remote builders available to this machine\.



*Type:*
list of (submodule)



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostName



The hostname of the remote builder\.



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostPublicKey



SSH host public key of the builder, for known_hosts



*Type:*
string

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.maxJobs



Max CPU cores for building\.



*Type:*
signed integer



*Default:*
` 4 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.speedFactor



idk for this one



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.sshKey



Path to private SSH key readable by the nix daemon (root)\. If not defined, will pull the sops secret ` {remote-hostname}-builder-key-{local-hostname} `\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.supportedFeatures



Supported nix features on this builder\.



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
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.systems



Architectures this remote builder supports building for\.



*Type:*
list of string



*Default:*

```
[
  "x86_64-linux"
]
```

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.user



Nix remote builder username\.



*Type:*
string



*Default:*
` "nixremote" `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/nix/remote-building.nix)



## programs\.enable



Whether to enable Programs\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/programs](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/programs)



## services\.harmonia\.package

The harmonia package to use\.



*Type:*
package



*Default:*
` pkgs.harmonia `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.cache\.enable



Whether to enable Harmonia: Nix binary cache written in Rust\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.cache\.settings



Settings to merge with the default configuration\.
For the list of the default configuration, see [https://github\.com/nix-community/harmonia/tree/master\#configuration](https://github\.com/nix-community/harmonia/tree/master\#configuration)\.



*Type:*
TOML value



*Default:*
` { } `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.cache\.signKeyPath



DEPRECATED: Use ` services.harmonia-dev.cache.signKeyPaths ` instead\. Path to the signing key to use for signing the cache



*Type:*
null or absolute path



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.cache\.signKeyPaths



Paths to the signing keys to use for signing the cache



*Type:*
list of absolute path



*Default:*
` [ ] `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.daemon\.enable



Whether to enable Harmonia daemon: Nix daemon protocol implementation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.daemon\.dbPath



Path to the Nix database



*Type:*
string



*Default:*
` "/nix/var/nix/db/db.sqlite" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.daemon\.logLevel



Log level for the daemon



*Type:*
string



*Default:*
` "info" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.daemon\.socketPath



Path where the daemon socket will be created



*Type:*
string



*Default:*
` "/run/harmonia-daemon/socket" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.harmonia\.daemon\.storeDir



Path to the Nix store directory



*Type:*
string



*Default:*
` "/nix/store" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/harmonia.nix)



## services\.ncps\.enable



Whether to enable ncps: Nix binary cache proxy service implemented in Go\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.package



The ncps package to use\.



*Type:*
package



*Default:*
` pkgs.ncps `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.analytics\.reporting\.enable



Enable reporting anonymous usage statistics (DB type, Lock type, Total Size) to the project maintainers\.



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.analytics\.reporting\.samples



Whether to enable Enable printing the analytics samples to stdout\. This is useful for debugging and verification purposes only…



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.allowDeleteVerb



Whether to enable Whether to allow the DELETE verb to delete narinfo and nar files from
the cache\.
\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.allowPutVerb



Whether to enable Whether to allow the PUT verb to push narinfo and nar files directly
to the cache\.
\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.cdc\.enabled



Whether to enable Whether to enable Content-Defined Chunking (CDC) for deduplication (experimental)\.
\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.cdc\.avg



The average chunk size for CDC in bytes\.



*Type:*
32 bit unsigned integer; between 0 and 4294967295 (both inclusive)



*Default:*
` 65536 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.cdc\.max



The maximum chunk size for CDC in bytes\.



*Type:*
32 bit unsigned integer; between 0 and 4294967295 (both inclusive)



*Default:*
` 262144 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.cdc\.min



The minimum chunk size for CDC in bytes\.



*Type:*
32 bit unsigned integer; between 0 and 4294967295 (both inclusive)



*Default:*
` 16384 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.database\.pool\.maxIdleConns



Maximum number of idle connections in the pool (0 = use
database-specific defaults)\.



*Type:*
signed integer



*Default:*
` 0 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.database\.pool\.maxOpenConns



Maximum number of open connections to the database (0 = use
database-specific defaults)\.



*Type:*
signed integer



*Default:*
` 0 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.databaseURL



The URL of the database (currently only SQLite is supported)



*Type:*
null or string



*Default:*
` "sqlite:/var/lib/ncps/db/db.sqlite" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.databaseURLFile



File containing the URL of the database\.



*Type:*
null or absolute path



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.hostName



The hostname of the cache server\. **This is used to generate the
private key used for signing store paths (\.narinfo)**



*Type:*
string

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.allowDegradedMode



Allow falling back to local locks if Redis is unavailable (WARNING:
breaks HA guarantees)\.



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.backend



Lock backend to use: ‘local’ (single instance), ‘redis’
(distributed)\.



*Type:*
one of “local”, “redis”



*Default:*
` "local" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.downloadTTL



TTL for download locks (per-hash locks)\.



*Type:*
string



*Default:*
` "5m0s" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.lruTTL



TTL for LRU lock (global exclusive lock)\.



*Type:*
string



*Default:*
` "30m0s" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.redisKeyPrefix



Prefix for all Redis lock keys (only used when Redis is
configured)\.



*Type:*
string



*Default:*
` "ncps:lock:" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.retry\.initialDelay



Initial retry delay for distributed locks\.



*Type:*
string



*Default:*
` "100ms" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.retry\.jitter



Enable jitter in retry delays to prevent thundering herd\.



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.retry\.maxAttempts



Maximum number of retry attempts for distributed locks\.



*Type:*
signed integer



*Default:*
` 3 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lock\.retry\.maxDelay



Maximum retry delay for distributed locks (exponential backoff
caps at this)\.



*Type:*
string



*Default:*
` "2s" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lru\.schedule



The cron spec for cleaning the store to keep it under
config\.ncps\.cache\.maxSize\. Refer to
https://pkg\.go\.dev/github\.com/robfig/cron/v3\#hdr-Usage for
documentation\.



*Type:*
null or string



*Default:*
` null `



*Example:*
` "0 2 * * *" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.lru\.scheduleTimeZone



The name of the timezone to use for the cron schedule\. See
[https://en\.wikipedia\.org/wiki/List_of_tz_database_time_zones](https://en\.wikipedia\.org/wiki/List_of_tz_database_time_zones)
for a comprehensive list of possible values for this setting\.



*Type:*
string



*Default:*
` "Local" `



*Example:*
` "America/Los_Angeles" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.maxSize



The maximum size of the store\. It can be given with units such as
5K, 10G etc\. Supported units: B, K, M, G, T\.



*Type:*
null or string



*Default:*
` null `



*Example:*
` "100G" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis



Configure Redis\.



*Type:*
null or (submodule)



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.addresses



A list of host:port for the Redis servers that are part of a cluster\.
To use a single Redis instance, just set this to its single address\.



*Type:*
list of string



*Example:*

```
''
  ["redis0:6379" "redis1:6379"]
''
```

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.database



Redis database number (0-15)



*Type:*
signed integer



*Default:*
` 0 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.password



Redis password for authentication (for Redis ACL)\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.passwordFile



File containing the redis password for authentication (for Redis ACL)\.



*Type:*
null or absolute path



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.poolSize



Redis connection pool size\.



*Type:*
signed integer



*Default:*
` 10 `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.useTLS



Use TLS for Redis connection\.



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.redis\.username



Redis username for authentication (for Redis ACL)\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.secretKeyPath



The path to load the secretKey for signing narinfos\. Leave this
empty to automatically generate a private/public key\.



*Type:*
null or absolute path



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.signNarinfo



Whether to sign narInfo files or passthru as-is from upstream



*Type:*
boolean



*Default:*
` true `



*Example:*
` false `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.local



The local directory for storing configuration and cached store
paths\. This is ignored if services\.ncps\.cache\.storage\.s3 is not
null\.



*Type:*
absolute path



*Default:*
` "/var/lib/ncps" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3



Use S3 for storage instead of local storage\.



*Type:*
null or (submodule)



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.accessKeyIdPath



The path to a file containing only the access-key-id\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.bucket



The name of the S3 bucket\.



*Type:*
string

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.endpoint



S3-compatible endpoint URL with scheme\.



*Type:*
string



*Example:*
` "https://s3.amazonaws.com" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.forcePathStyle



Force path-style S3 addressing (bucket/key vs key\.bucket)\.



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.region



The S3 region\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.storage\.s3\.secretAccessKeyPath



The path to a file containing only the secret-access-key\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.tempPath



The path to the temporary directory that is used by the cache to download NAR files



*Type:*
absolute path



*Default:*
` "/tmp" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.upstream\.dialerTimeout



Timeout for establishing TCP connections to upstream caches (e\.g\., 3s, 5s, 10s)\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.upstream\.publicKeys



A list of public keys of upstream caches in the format
` host[-[0-9]*]:public-key `\. This flag is used to verify the
signatures of store paths downloaded from upstream caches\.



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
]
```

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.upstream\.responseHeaderTimeout



Timeout for waiting for upstream server’s response headers\.



*Type:*
null or string



*Default:*
` null `



*Example:*
` "5s" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.cache\.upstream\.urls



A list of URLs of upstream binary caches\.



*Type:*
list of string



*Example:*

```
[
  "https://cache.nixos.org"
]
```

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.logLevel



Set the level for logging\. Refer to
[https://pkg\.go\.dev/github\.com/rs/zerolog\#readme-leveled-logging](https://pkg\.go\.dev/github\.com/rs/zerolog\#readme-leveled-logging) for
more information\.



*Type:*
one of “trace”, “debug”, “info”, “warn”, “error”, “fatal”, “panic”



*Default:*
` "info" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.netrcFile



The path to netrc file for upstream authentication\.
When unspecified ncps will look for \`\`$HOME/\.netrc\`\.



*Type:*
null or absolute path



*Default:*
` null `



*Example:*
` "/etc/nix/netrc" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.openTelemetry\.enable



Whether to enable Enable OpenTelemetry logs, metrics, and tracing\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.openTelemetry\.grpcURL



Configure OpenTelemetry gRPC URL\. Missing or “https” scheme enables
secure gRPC, “insecure” otherwise\. Omit to emit telemetry to
stdout\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.prometheus\.enable



Whether to enable Enable Prometheus metrics endpoint at /metrics\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## services\.ncps\.server\.addr



The address and port the server listens on\.



*Type:*
string



*Default:*
` ":8501" `

*Declared by:*
 - [/nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps\.nix](file:///nix/store/anvdcc2arw7kqrvwnidvhw6ypkkvws68-source/nixos/modules/services/networking/ncps.nix)



## theming\.enable



Whether to enable Theming using stylix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/theming](file:///nix/store/9j9cy7aqs1jwq0lmbwzqp4h0rbyy0agq-source/modules/nixos/theming)


