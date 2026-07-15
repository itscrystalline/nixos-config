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



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<nixpkgs/lib/modules\.nix>](https://github.com/NixOS/nixpkgs/blob//lib/modules.nix)



## bluetooth\.enable



Whether to enable bluetooth\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/bluetooth](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/bluetooth)



## boot\.bootloader



Boot loader\. ‘limine’, ‘systemd-boot’, ‘grub’ or ‘generic’\.



*Type:*
one of “systemd-boot”, “generic”, “grub”, “limine”

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.extraBootEntries



Additional boot entries for systemd-boot/limine/grub\. Does nothing on ‘generic’\.



*Type:*
null or strings concatenated with “\\n” or (attribute set)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.mountPoint



EFI mount point\.



*Type:*
string



*Default:*

```nix
"/boot"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.network



Whether to enable network in the initrd\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.stage1AvailableModules



Kernel modules available during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.stage1LoadedModules



Kernel modules loaded during stage 1\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## boot\.verbosity



Boot logging verbosity\. Can be ‘silent’, ‘verbose’ or a plymouth package\.



*Type:*
one of “silent”, “verbose” or (submodule)



*Default:*

```nix
"verbose"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/boot.nix)



## compat\.nix-ld\.enable



Whether to enable nix-ld w/ libs\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/compatibility/nix-ld\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/compatibility/nix-ld.nix)



## compat\.steam-run\.enable



Whether to enable steam-run\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/compatibility/steam-run\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/compatibility/steam-run.nix)



## core\.arch



Architecture/Platform of the machine\.



*Type:*
string



*Default:*

```nix
"x86_64-linux"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.fileSystems



Filesystems to configure in /etc/fstab\. Mirrors that of NixOS’s\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.localization



The system’s localization settings\.



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.localization\.keymap



Console keymap\.



*Type:*
string



*Default:*

```nix
"us"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.localization\.locale



System locale\.



*Type:*
string



*Default:*

```nix
"ja_JP.UTF-8"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.localization\.timezone



Time zone\.



*Type:*
string



*Default:*

```nix
"Asia/Bangkok"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.name



System name\.



*Type:*
string



*Default:*

```nix
"localhost"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.primaryUser



Main user’s username\.



*Type:*
string



*Default:*

```nix
"itscrystalline"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.primaryUserSshKeys



SSH Keys allowed to log in to the ` primaryUser `\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## core\.stateVersion



NixOS State version\.



*Type:*
string



*Default:*

```nix
"24.11"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos)



## crystals-services\.argonone\.enable



Whether to enable Argonone fan/power controller\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.fans



Fan speed percentages corresponding to each temperature threshold\.



*Type:*
list of signed integer



*Default:*

```nix
[
  30
  60
  100
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.hysteresis



Temperature hysteresis in °C before stepping down fan speed\.



*Type:*
signed integer



*Default:*

```nix
5
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone.nix)



## crystals-services\.argonone\.temps



Temperature thresholds in °C for fan speed steps\.



*Type:*
list of signed integer



*Default:*

```nix
[
  45
  60
  70
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/argonone.nix)



## crystals-services\.avahi\.enable



Whether to enable Avahi MDNS/SD\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/avahi\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/avahi.nix)



## crystals-services\.blocky\.enable



Whether to enable Blocky DNS server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.allowList



Custom allowlist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.customDNS



Custom DNS mappings of \<domain> to \<ip address>\. \<domain> is affixed with ` config.crystals-services.nginx.local.suffix `\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  "" = "1.2.3.4";
  "test" = "5.6.7.8";
}

```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.denyList



Custom denylist entries (one domain per line)



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky.nix)



## crystals-services\.blocky\.listenAddress



Blocky’s listen IP address\. defaults to 0\.0\.0\.0 (all interfaces)\.



*Type:*
string



*Default:*

```nix
"0.0.0.0"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/blocky.nix)



## crystals-services\.boinc\.enable



Whether to enable BOINC project computing\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc.nix)



## crystals-services\.boinc\.projects



List of BOINC projects to join\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc.nix)



## crystals-services\.boinc\.projects\.\*\.key



The account weak key secret name that is associated with this project\. prepended by ` boinc_ ` and appended by ` _key `\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc.nix)



## crystals-services\.boinc\.projects\.\*\.url



The project’s URL\. Ends with a ` / `\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/boinc.nix)



## crystals-services\.cloudflared\.enable



Whether to enable Cloudflare tunnel\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/cloudflared\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/cloudflared.nix)



## crystals-services\.cloudflared\.domains



Domains to open to the public via cloudflare tunnels



*Type:*
attribute set of (attribute set)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/cloudflared\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/cloudflared.nix)



## crystals-services\.copyparty\.enable



Whether to enable copyparty\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty.nix)



## crystals-services\.copyparty\.volumes



Volumes to enable in copyparty\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty.nix)



## crystals-services\.copyparty\.volumes\.\<name>\.access



Users that can access this volume read only\.



*Type:*
attribute set of ((list of string) or string convertible to it)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty.nix)



## crystals-services\.copyparty\.volumes\.\<name>\.path



Host path for this volume\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/copyparty.nix)



## crystals-services\.create-ap\.enable



Whether to enable create_ap WiFi hotspot\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks



List of static DHCP leases for the hotspot



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.hostname



Hostname\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.ip



IP address\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.lease



Lease time\.



*Type:*
string



*Default:*

```nix
"infinite"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.create-ap\.dhcpLocks\.\*\.mac



MAC address\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/create-ap.nix)



## crystals-services\.docker\.enable



Whether to enable Docker\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/docker\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/docker.nix)



## crystals-services\.earlyoom\.enable



Whether to enable EarlyOOM\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/earlyoom\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/earlyoom.nix)



## crystals-services\.essentialServices



Essential systemd services to restart always\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services)



## crystals-services\.forgejo\.enable



Whether to enable forgejo server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.directory



Forgejo’s state directory\.



*Type:*
string



*Default:*

```nix
"/var/lib/forgejo"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.runner\.enable



Whether to enable forgejo actions runner\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.runner\.workers



How many runners to spin up



*Type:*
signed integer



*Default:*

```nix
1
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo.nix)



## crystals-services\.forgejo\.sync\.enable



Whether to enable syncing to github from forgejo\. requires importing the forgesync\.nixosModules\.default module\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/forgejo.nix)



## crystals-services\.home-assistant\.enable



Whether to enable Home Assistant\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/home-assistant\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/home-assistant.nix)



## crystals-services\.iw2tryhard-dev\.enable



Whether to enable personal website\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/iw2tryhard-dev\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/iw2tryhard-dev.nix)



## crystals-services\.localsend\.enable



Whether to enable localsend\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/localsend\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/localsend.nix)



## crystals-services\.manga\.enable



Whether to enable Suwayomi manga server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/manga\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/manga.nix)



## crystals-services\.monitoring\.enable



Whether to enable Grafana + Prometheus + Loki + Alloy monitoring stack\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring.nix)



## crystals-services\.monitoring\.enableOpenTelemetryCollector



Whether to enable OpenTelemetry Collector\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring.nix)



## crystals-services\.monitoring\.additionalOpenTelemeteryResourceAttributes



Additional resource attributes to add to OpenTelemetry\.



*Type:*
list of (attribute set)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/monitoring.nix)



## crystals-services\.nextcloud\.enable



Whether to enable Nextcloud\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.adminpassFile



Path to a file containing the Nextcloud admin password\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.domain



Domain name for Nextcloud\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.folder



Main Nextcloud data directory\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nextcloud\.statsTokenFile



Path to a file containing the Nextcloud serverinfo stats API token\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nextcloud.nix)



## crystals-services\.nfs\.enable



Whether to enable NFS server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.exports



Contents of /etc/exports\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs.nix)



## crystals-services\.nfs\.folder



Local directory to export via NFS (bind-mounted to /export)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nfs.nix)



## crystals-services\.nginx\.enable



Whether to enable Nginx reverse proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.local\.sites



Attrset of local sites\. the name constitutes a subdomain, an empty name means the domain apex\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.local\.sites\.\<name>\.aliases



Aliases for this domain



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.local\.sites\.\<name>\.extraConfig



Extra config for this site\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.local\.sites\.\<name>\.locations



Nginx locations\.



*Type:*
attribute set of (attribute set)



*Default:*

```nix
{
  "/" = { };
}
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.local\.suffix



suffix for local domains\.



*Type:*
string



*Default:*

```nix
"crys"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites



Attrset of local sites\. the name constitutes a subdomain, an empty name means the domain apex\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.acme



If set to true, Registers a TLS certificate for this site and it’s aliases\. else, this site uses the ACME cert of the site entered here\. if false, disables TLS\.



*Type:*
boolean or string



*Default:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.acmeReloadedService



The systemd service that is to be restarted when the certificate refreshes\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.acmeUser



The user that will have read access to the certificate dir \& file\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.aliases



Aliases for this domain



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.extraConfig



Extra config for this site\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.sites\.\<name>\.locations



Nginx locations\.



*Type:*
attribute set of (attribute set)



*Default:*

```nix
{
  "/" = { };
}
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nginx\.public\.suffix



suffix for local domains\.



*Type:*
string



*Default:*

```nix
"iw2tryhard.dev"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nginx.nix)



## crystals-services\.nix-binary-cache\.domain



local domain for all cache-related things\. this is affixed by ` config.crystals-services.nginx.local.suffix `\.



*Type:*
string



*Default:*

```nix
"cache"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.harmonia\.enable



Whether to enable Serve local nix store as cache\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.ncro\.enable



Whether to enable Lightweight HTTP proxy for optimizing Nix cache routes for fast access\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.ncro\.nixCaches



Nix cache config for ncro to use\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.ncro\.nixCaches\.\*\.public_key



Upstream public keys\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.ncro\.nixCaches\.\*\.url



Upstream cache URL\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.nix-binary-cache\.ncro\.publish



Whether to enable Publishing to the network via nginx\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/nix-binary-cache.nix)



## crystals-services\.pm\.enable



Whether to enable Laptop power management\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/power-management\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/power-management.nix)



## crystals-services\.pm\.profile



A TLP preset profile, or custom\.



*Type:*
one of “workstation”, “server” or (attribute set)



*Default:*

```nix
"workstation"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/power-management\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/power-management.nix)



## crystals-services\.printing\.enable



Whether to enable printing via CUPS\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.defaultPrinter



Default printer name\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.drivers



Printer driver packages to install\.



*Type:*
list of package



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers



Printers to configure via CUPS\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.deviceUri



Printer device URI\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.location



Printer location\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.model



Printer PPD model\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.name

Printer name\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.printers\.\*\.ppdOptions



PPD options\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.printing\.shared



Whether to enable printer sharing over the network\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/printing.nix)



## crystals-services\.restartOnResumeServices



Services that need restarting when the system resumes from sleep\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services)



## crystals-services\.scanservjs\.enable



Whether to enable scanservjs network scanner service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.scanservjs\.nginxVhost



Nginx virtual host name to proxy scanservjs under\. Null to disable\.



*Type:*
null or string



*Default:*

```nix
"scan"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/scanservjs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/scanservjs.nix)



## crystals-services\.ssh\.enable



Whether to enable SSH server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/ssh.nix)



## crystals-services\.ssh\.enablePasswordLogin



Whether to enable SSH password login\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/ssh.nix)



## crystals-services\.stalwart\.enable



Whether to enable stalwart mail server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart.nix)



## crystals-services\.stalwart\.directory



Directory to store stalwart data



*Type:*
absolute path



*Default:*

```nix
"/var/lib/stalwart-mail"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart.nix)



## crystals-services\.stalwart\.host



Main stalwart hostname\.



*Type:*
null or string



*Default:*

```nix
"iw2tryhard.dev"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/stalwart.nix)



## crystals-services\.tailscale\.enable



Whether to enable Tailscale\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale.nix)



## crystals-services\.tailscale\.asExitNode



Whether to enable the use of this host as an exit node, only if ‘role’ is set to ‘server’…



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale.nix)



## crystals-services\.tailscale\.role



The tailscale role this host using\. This is to configure required options for tailscale’s features to work\. If set to ‘server’, this also configures the auth key\.



*Type:*
one of “client”, “server”



*Default:*

```nix
"client"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/tailscale.nix)



## crystals-services\.wakeonlan\.enable



Whether to enable Wake-on-LAN for this host (needs hardware support)\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/wakeonlan\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/wakeonlan.nix)



## crystals-services\.wakeonlan\.interface



The interface to enable WOL on\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/wakeonlan\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/services/wakeonlan.nix)



## gui\.enable



Whether to enable GUI support\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui)



## gui\.audio\.enable



Whether to enable PipeWire audio\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/audio\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/audio.nix)



## gui\.flatpak\.enable



Whether to enable flatpak\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/flatpak\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/flatpak.nix)



## gui\.graphics\.enable



Whether to enable graphics\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.enableSpecialisation



Whether to enable noDGPU specialisation\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.enable



Whether to enable NVIDIA PRIME\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.intelBusID



The Intel GPU’s bus ID\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics.nix)



## gui\.graphics\.prime\.nvidiaBusID



The NVIDIA GPU’s bus ID\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/graphics.nix)



## gui\.niri\.enable



Whether to enable niri \& friends (nixos)\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/niri\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/niri.nix)



## gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/obs\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/obs.nix)



## gui\.steam\.enable



Whether to enable steam\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/steam\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/gui/steam.nix)



## hardware\.raspberrypi\.enable



Whether to enable Raspberry Pi 4 hardware support\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/hardware/raspberrypi\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/hardware/raspberrypi.nix)



## hm\.bluetooth\.enable



Whether to enable Bluetooth\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager)



## hm\.core\.stateVersion



HM State version\.



*Type:*
string



*Default:*

```nix
"24.11"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager)



## hm\.core\.username



Username of this user\.



*Type:*
string



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager)



## hm\.flatpak\.enable



Whether to enable Flatpak support\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/flatpak\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/flatpak.nix)



## hm\.gui\.enable



Whether to enable GUI configuration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui)



## hm\.gui\.niri\.enable



Whether to enable niri \& friends (home-manager)\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/niri\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/niri.nix)



## hm\.gui\.shell\.enable



Whether to enable Noctalia shell\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/shell\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/shell.nix)



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

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.authorizedKeys



SSH public keys of Nix clients permitted to use this machine
as a builder\. Each entry is the contents of the client’s
builder key (e\.g\. /etc/nix/builder-key\.pub)\.



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "ssh-ed25519 AAAA... nix-remote@client-host"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.maxJobs



Suggested maxJobs value for clients to use\.



*Type:*
signed integer



*Default:*

```nix
4
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.speedFactor



Suggested speedFactor value for clients to use\.



*Type:*
signed integer



*Default:*

```nix
1
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.asBuilderConfig\.systems



Systems this machine can natively build for\.



*Type:*
list of string



*Default:*

```nix
[
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



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

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.hostName



Hostname or IP address of the remote builder\.
Must be reachable from this machine (LAN, Tailscale, etc\.)\.



*Type:*
string



*Example:*

```nix
"builder.local"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.maxJobs



Maximum parallel builds to run on this builder\.



*Type:*
signed integer



*Default:*

```nix
4
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



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

```nix
"/etc/nix/builder-key"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.publicKeyPath



The SSH *host* public key of the remote builder\.
Written into ~/\.ssh/known_hosts and also used to set
StrictHostKeyChecking in the SSH match block for this builder\.

Find this by running on the builder:
cat /etc/ssh/ssh_host_ed25519_key\.pub



*Type:*
string



*Example:*

```nix
"ssh-ed25519 AAAA..."
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.speedFactor



Relative speed hint; higher values are preferred\.



*Type:*
signed integer



*Default:*

```nix
1
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.supportedFeatures



Features declared by this builder\.



*Type:*
list of string



*Default:*

```nix
[
  "nixos-test"
  "big-parallel"
  "kvm"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.systems



System types this builder can build for\.



*Type:*
list of string



*Default:*

```nix
[
  "x86_64-linux"
]
```



*Example:*

```nix
[
  "x86_64-linux"
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.nix\.remoteBuilders\.\*\.user



The user to SSH into on the remote builder\.
Must be trusted in the builder’s nix\.settings\.trusted-users\.



*Type:*
string



*Default:*

```nix
"nixremote"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/nix/remote-building.nix)



## hm\.programs\.cli\.enable



Whether to enable CLI tools\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/cli\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.cli\.dev\.enable



Whether to enable development tools\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/dev\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/dev.nix)



## hm\.programs\.cli\.dev\.ai\.enable



Whether to enable ai stuff\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ai\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ai.nix)



## hm\.programs\.cli\.fastfetch\.profile



How much info fastfetch should produce\.



*Type:*
one of “full”, “minimal”



*Default:*

```nix
"minimal"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/cli\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/cli.nix)



## hm\.programs\.games\.enable



Whether to enable games\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/games\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/games.nix)



## hm\.programs\.gui\.enable



Whether to enable GUI apps\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.largePrograms\.enable



Whether to enable Large GUI apps\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.obs\.enable



Whether to enable OBS Studio\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/gui.nix)



## hm\.programs\.gui\.vicinae\.enable



Whether to enable Vicinae launcher\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.own



List of vicinae plugins to install\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.gui\.vicinae\.plugins\.raycast



List of vicinae-compatable raycast plugins to install\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/gui/vicinae.nix)



## hm\.programs\.ides\.enable



Whether to enable IDEs and editors\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ides\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ides.nix)



## hm\.programs\.ssh\.authorizedKeys



Public key strings authorized to log into this user\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts



Hosts to configure SSH for\. Automatically adds them to ssh settings and known_hosts\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.hostname



Hostname to connect to via SSH\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.privateKeyPath



Path to the private key on the host file system\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.publicKeyPath



Path to the public key on the host file system\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.programs\.ssh\.hosts\.\<name>\.user



User to connect to via SSH\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/programs/ssh.nix)



## hm\.services\.mpris-proxy\.enable



Whether to enable home MPRIS proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/services/mpris\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/services/mpris.nix)



## hm\.services\.nextcloud\.enable



Whether to enable Nextcloud integration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/services/nextcloud\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/services/nextcloud.nix)



## hm\.theming\.enable



Whether to enable theming configuration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/theming](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/home-manager/theming)



## kernel\.package



Linux kernel package (linuxPackages set)\.



*Type:*
raw value

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.cmdline



Linux kernel cmdline arguments\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.emulatedArchitectures



Binfmt emulated architectures\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.enable



Whether to enable hibernation\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.hibernate\.device



Device to hibernate to\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.modprobeConfig



Extra modprobe config\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.moduleBlacklist



Kernel modules blacklisted\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2ModulePackages



Kernel module packages available during stage 2\.



*Type:*
list of package



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.stage2Modules



Kernel modules available during stage 2\.



*Type:*
(attribute set of boolean) or (list of string) convertible to it



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.supportedFilesystems



Supported Filesystems\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## kernel\.sysctl



Linux kernel sysctl options\. Passed through to ` boot.kernel.sysctl `\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/kernel/kernel.nix)



## network\.dhcp



Whether to enable DHCP\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.mounts



List of Network mounts\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.automount



To configure an automount for this mount point\.



*Type:*
boolean

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.mountPoint



Mount point on the local filesystem\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.remote



Mount point source remote\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts.nix)



## network\.mounts\.\*\.type



Mount point type\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network/network-mounts.nix)



## network\.ports\.tcp



TCP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.ports\.tcpRange



TCP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.ports\.udp



UDP ports to open\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.ports\.udpRange



UDP port ranges to open\.



*Type:*
list of attribute set of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.profiles



NetworkManager profiles automatically configured via known-networks or inline attrsets\.



*Type:*
list of (string or (attribute set))



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.trustedInterfaces



Trusted Network Interfaces\.



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## network\.unmanagedInterfaces



Network interfaces that NetworkManager will not manage\.



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "end0"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/network)



## nix\.asBuilderConfig



Configure this machine as a remote builder\.



*Type:*
null or (submodule)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.authorizedKeys



SSH public keys of machines allowed to use this builder



*Type:*
list of string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.emulatedSystems



Extra systems to support via binfmt emulation (e\.g\. aarch64-linux)



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "aarch64-linux"
  "armv7l-linux"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.maxJobs



Max parallel build jobs to accept



*Type:*
signed integer



*Default:*

```nix
4
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.speedFactor



Relative speed hint for client scheduling (higher = preferred)



*Type:*
signed integer



*Default:*

```nix
1
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.systems



Systems this machine can build for



*Type:*
list of string



*Default:*

```nix
[
  "aarch64-linux"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.asBuilderConfig\.user

User that clients SSH in as to perform builds



*Type:*
string



*Default:*

```nix
"nixremote"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.autoUpdate\.enable



Whether to enable automatic updates\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.dates



When automatic updates happen\. The default is at 6PM local time\.



*Type:*
string



*Default:*

```nix
"*-*-* 18:00:00"
```



*Example:*
` *-1..12/3-1..31/2 00:30:00 ` => half past midnight on every other day on every 3rd month\.

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.remoteUpdaterHost



Hostname to build the update on\. Takes effect only if ` type ` is ` remote `\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update.nix)



## nix\.autoUpdate\.type



Update type\. ‘self’ means that the system will update itself, ‘remote’ means that it will request another host to build for it\.



*Type:*
one of “self”, “remote”



*Default:*

```nix
"self"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/auto-update.nix)



## nix\.keepGenerations



How many NixOS generations to keep\.



*Type:*
signed integer or floating point number



*Default:*

```nix
3
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix)



## nix\.nh\.enable



Whether to enable nix-helper\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix)



## nix\.nh\.dates



How often to run ` nh clean `\. systemd timer format\.



*Type:*
string



*Default:*

```nix
"weekly"
```



*Example:*

```nix
"weekly"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix)



## nix\.nh\.keepSince



NH option --keep-since, how long to keep lingering store paths for\.



*Type:*
string



*Default:*

```nix
"1w"
```



*Example:*

```nix
"1w"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix)



## nix\.remoteBuilders



Remote builders available to this machine\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostName



The hostname of the remote builder\.



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.hostPublicKey



SSH host public key of the builder, for known_hosts



*Type:*
string

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.maxJobs



Max CPU cores for building\.



*Type:*
signed integer



*Default:*

```nix
4
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.speedFactor



idk for this one



*Type:*
signed integer



*Default:*

```nix
1
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.sshKey



Path to private SSH key readable by the nix daemon (root)\. If not defined, will pull the sops secret ` {remote-hostname}-builder-key-{local-hostname} `\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.supportedFeatures



Supported nix features on this builder\.



*Type:*
list of string



*Default:*

```nix
[
  "nixos-test"
  "big-parallel"
  "kvm"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.systems



Architectures this remote builder supports building for\.



*Type:*
list of string



*Default:*

```nix
[
  "x86_64-linux"
]
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## nix\.remoteBuilders\.\*\.user



Nix remote builder username\.



*Type:*
string



*Default:*

```nix
"nixremote"
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building\.nix](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/nix/remote-building.nix)



## programs\.enable



Whether to enable Programs\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/programs](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/programs)



## theming\.enable



Whether to enable Theming using stylix\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [/nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/theming](file:///nix/store/nadx1qc8fcqjpgnz084l6lj0lr3ykc18-source/modules/nixos/theming)


