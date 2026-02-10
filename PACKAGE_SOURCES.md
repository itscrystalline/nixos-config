# cwystaws-meowchine Package Source Analysis

This document analyzes where the ~6000 packages in the `cwystaws-meowchine` NixOS
configuration come from. Packages come from both **direct** declarations and
**transitive** dependencies pulled in by enabled NixOS/HM modules.

---

## Summary: Estimated Package Breakdown

| Source | Est. Closure Packages | Module / File | Status |
|---|---|---|---|
| **~~GNOME Desktop Environment~~** | ~~~2000–2500~~ | `host/modules/main/services.nix` | **REMOVED** — replaced with GDM-only + individual GNOME apps |
| **~~CUDA Toolkit~~** | ~~~400–600~~ | `host/modules/main/graphics.nix` | **REMOVED** — use devenv/nix-shell when needed |
| **~~VirtualBox~~** | ~~~100–200~~ | `host/modules/main/virtualisation.nix` | **REMOVED** — KVM/QEMU covers virtualisation |
| **Steam + Proton** | ~250–400 | `host/modules/main/games.nix` | Kept |
| **Chromium** | ~200–300 | `home/modules/gui.nix` | Kept |
| **LibreOffice** | ~150–250 | `home/modules/gui.nix` | Kept |
| **KDE/Qt packages (kdenlive, qt5ct, qt6ct, kvantum)** | ~200–300 | `home/modules/gui.nix`, `host/modules/common/theming.nix` | Kept |
| **Docker** | ~50–100 | `host/modules/main/virtualisation.nix` | Kept |
| **libvirtd + QEMU + virt-manager** | ~100–200 | `host/modules/main/virtualisation.nix` | Kept |
| **Blender (custom-built from flake)** | ~100–200 | `home/modules/gui/blender.nix` | Kept |
| **OBS Studio + plugins** | ~50–100 | `home/modules/gui.nix` | Kept |
| **nix-ld library set** | ~50–150 | `host/modules/common/compat.nix` | Kept |
| **Zen Browser (Firefox fork)** | ~100–150 | `home/modules/gui-linux.nix` | Kept |
| **IDEs & language tooling** | ~100–200 | `home/modules/ides.nix` | Kept |
| **CLI tools (zsh, starship, bat, eza, etc.)** | ~50–100 | `home/modules/cli.nix` | Kept |
| **Fonts** | ~30–50 | `host/modules/common/theming.nix`, `home/modules/gui.nix` | Kept |
| **Stylix theming** | ~20–50 | `host/modules/common/theming.nix` | Kept |
| **Flatpak + nix-flatpak** | ~10–30 | `host/modules/main/flatpak.nix` | Kept |
| **Sunshine (remote desktop)** | ~20–40 | `host/modules/main/services.nix` | Kept |
| **Vicinae extensions (npm builds)** | ~30–80 | `home/modules/gui-linux.nix` | Kept |
| **Niri window manager** | ~20–40 | niri flake + `home/modules/niri.nix` | Kept |
| **GNOME apps (nautilus, text-editor, loupe, totem, papers, disks, file-roller)** | ~50–100 | `host/modules/main/services.nix` | **NEW** — individual apps instead of full desktop |
| **Misc services & tools** | ~50–100 | Various | Kept |
| **NixOS base system + kernel** | ~500–700 | Implicit | Kept |
| **NVIDIA drivers** | ~30–50 | `host/modules/main/graphics.nix` | Kept |
| **Home Manager infrastructure** | ~30–50 | Implicit | Kept |

> **Note:** Closure sizes overlap heavily — many packages are shared dependencies.
> The total won't equal the sum of these rows.
>
> **Estimated savings:** ~2500–3300 packages removed (GNOME desktop ~2000–2500,
> CUDA ~400–600, VirtualBox ~100–200, minus shared-dependency overlap).

---

## Top 5 Biggest Contributors (in order)

### 1. ~~GNOME Desktop Environment~~ — REMOVED

**File:** `host/modules/main/services.nix`

Previously, `services.desktopManager.gnome.enable = true` pulled in ~2000–2500
packages. Since niri is the actual window manager, GNOME was only providing GDM
and supporting services.

**What changed:** Disabled `services.desktopManager.gnome.enable`. GDM is kept
as the display manager. Essential GNOME apps (Nautilus, GNOME Text Editor,
Loupe, Totem, Papers, GNOME Disks, File Roller) are now installed individually
as `environment.systemPackages` since they serve as default file handlers.

### 2. ~~CUDA Toolkit~~ — REMOVED

**File:** `host/modules/main/graphics.nix`

Previously, `nixpkgs.config.cudaSupport = true` and `cudatoolkit` added
~400–600 packages and caused CUDA-capable packages (e.g. Blender) to rebuild
with CUDA support.

**What changed:** Both `cudaSupport` and `cudatoolkit` removed. Use
`nix develop` or `devenv` for CUDA projects when needed.

### 3. Steam + Gaming (~250–400 packages)

**File:** `host/modules/main/games.nix`
```nix
programs.steam.enable = true;
```

Steam uses an FHS environment with a large set of 32-bit and 64-bit libraries,
plus Proton/Wine dependencies. Hard to trim — kept as-is.

### 4. Chromium (~200–300 packages)

**File:** `home/modules/gui.nix`
```nix
programs.chromium.enable = true;
```

Chromium has a massive build closure. It's used here only for the LINE webapp.

**Possible actions to reduce:**
- If the LINE extension can run in Zen Browser (Firefox-based), Chromium could
  potentially be removed entirely.

### 5. ~~VirtualBox~~ — REMOVED

**File:** `host/modules/main/virtualisation.nix`

Previously added ~100–200 packages. KVM/QEMU + virt-manager (which are kept)
cover virtualisation needs.

---

## Detailed Module-by-Module Breakdown

### NixOS System Modules (enabled for cwystaws-meowchine)

#### `host/modules/main/services.nix` — Desktop Services
- `services.displayManager.gdm.enable` → GDM login manager
- ~~`services.desktopManager.gnome.enable`~~ → **REMOVED**
- `services.gvfs.enable` → GNOME Virtual File System
- Essential GNOME apps installed individually: nautilus, gnome-text-editor,
  loupe, totem, papers, gnome-disk-utility, file-roller
- `services.teamviewer.enable` → TeamViewer
- `services.sunshine` → Remote desktop (Sunshine)
- `services.fwupd` → Firmware updater
- `services.ananicy` + `ananicy-cpp` → Auto nice daemon
- `services.tlp` → Power management
- `services.thermald`, `services.upower`, `services.earlyoom`

#### `host/modules/main/graphics.nix` — Graphics & NVIDIA
- ~~`cudatoolkit`~~ → **REMOVED**
- ~~`nixpkgs.config.cudaSupport = true`~~ → **REMOVED**
- `nvtopPackages.nvidia`, `nvtopPackages.intel` → GPU monitors
- `intel-gpu-tools`, `libva-utils` → Intel GPU utilities
- NVIDIA Optimus configuration + proprietary drivers

#### `host/modules/main/games.nix` — Gaming
- `programs.steam.enable` → **Steam** (LARGE, FHS environment)
- `gamemode` → Performance optimizer
- `protonup-qt` → Proton version manager

#### `host/modules/main/virtualisation.nix` — Virtualisation
- ~~`virtualisation.virtualbox.host.enable`~~ → **REMOVED**
- `virtualisation.libvirtd` + `virtiofsd` → KVM/QEMU
- `virtualisation.docker` → Docker
- `programs.virt-manager` → VM manager GUI
- `distrobox` → Container manager

#### `host/modules/main/programs.nix` — Desktop Programs
- `polkit_gnome`, `gnome-keyring`, `nautilus-python`
- `programs.nautilus-open-any-terminal`
- `programs.ydotool`
- `programs.obs-studio` (with `droidcam-obs` plugin)
- `programs.localsend`

#### `host/modules/common/compat.nix` — Compatibility (default enabled)
- `pkgs.steam-run` → FHS environment runner
- `pkgs.xorg.xhost`
- `programs.nix-ld` with **~60+ libraries** (SDL, GTK, X11, etc.)

#### `host/modules/common/theming.nix` — Theming (default enabled)
- `kdePackages.qtstyleplugin-kvantum`, `kdePackages.qt6ct`, `libsForQt5.qt5ct`
- `stylix.enable = true` → Base16 theming system
- 8 font packages (Noto, Inter, JetBrains Mono, Material Symbols, etc.)

#### `host/modules/common/security.nix` — Security (default enabled)
- `git-crypt`
- `services.openssh`
- `security.doas`, `security.polkit`

#### `host/modules/main/boot.nix` — Boot
- Bootloader, kernel configuration

#### `host/modules/main/network.nix` — Networking
- NetworkManager, firewall, etc.

#### Extra NixOS flake modules for cwystaws-meowchine:
- `inputs.nix-flatpak.nixosModules.nix-flatpak` → Flatpak integration
- `inputs.niri.nixosModules.niri` → Niri window manager
- `inputs.binaryninja.nixosModules.binaryninja` → Binary Ninja RE tool
- `nixos-hardware.nixosModules.asus-fx506hm` → ASUS laptop hardware tweaks
- `inputs.nur.modules.nixos.default` → NUR overlay
- `inputs.stylix.nixosModules.stylix` → Stylix theming

---

### Home Manager Modules (enabled for cwystaws-meowchine)

#### `home/modules/gui.nix` — GUI Applications
- `vesktop` → Discord client
- `beeper` → Multi-messenger
- `keepassxc` → Password manager
- `vlc` → Media player
- `kdePackages.kdenlive` → **Video editor** (pulls in KDE/Qt libraries)
- `gimp` → Image editor
- `audacity` → Audio editor
- `blockbench` → 3D modeler
- `libreoffice` → **Office suite** (LARGE)
- `logisim-evolution` → Logic simulator (Java-based)
- `wireshark` → Network analyzer
- `programs.chromium` → **Chromium browser** (LARGE)
- `programs.obs-studio` → Screen recorder + plugins
- `programs.kitty`, `programs.ghostty` → Terminal emulators
- `programs.fuzzel` → Application launcher
- 8 font packages (duplicated from theming.nix)

#### `home/modules/gui-linux.nix` — Linux GUI Applications
- `teams-for-linux` → Microsoft Teams
- `youtube-music` → YouTube Music client
- `pavucontrol` → PulseAudio volume control
- `hyprpicker`, `alsa-utils`, `tesseract`, `gparted`, `mission-center`
- `valent` → KDE Connect alternative
- `programs.zen-browser` → **Zen Browser** (Firefox fork, LARGE)
- `services.vicinae` with **13 extensions** (each built via npm)
- Flatpak: Flatseal, Zoom

#### `home/modules/gui/blender.nix` — Blender
- Custom-patched **Blender** from flake (with CUDA support if `cudaSupport`)
- BlenderKit addon

#### `home/modules/cli.nix` — CLI Tools (~30 packages)
- `zoxide`, `sshfs`, `nh`, `git-crypt`, `tmux`, `byobu`
- `cmake`, `meson`, `brightnessctl`, `ddcutil`, `swww`, `mpvpaper`
- `sass`, `sassc`, `libnotify`, `cava`, `yad`, `jq`, `pywal`
- `lsof`, `swappy`, `qrtool`, `playerctl`, `ydotool`, `socat`, `jocalsend`
- Programs: zsh, bash, fish, zoxide, starship, btop, yt-dlp, hyfetch,
  fastfetch, lazygit, nix-index, bat, eza, zellij, fzf, occasion

#### `home/modules/ides.nix` — IDEs & Dev Tools (~25 packages)
- `arduino-ide`, `neovide`, `unityhub` (GUI only)
- `sanzenvim` (custom Neovim config from flake)
- `gcc`, `clang-tools`, `arduino-cli`, `delta`
- 10+ formatters: `alejandra`, `prettierd`, `stylua`, `black`, `rustfmt`, etc.
- 6+ language servers: typescript, vue, yaml, verilator, verible, veridian

#### `home/modules/dev.nix` — Dev Tools
- `gnumake`, `devenv`, `nixd`, `gh`, `python3`, `filezilla` (GUI)

#### `home/modules/games.nix` — Games
- `prismlauncher` (with `graalvm-ce`, `zulu8`, `zulu21`)
- `itch`, `mcpelauncher-ui-qt`, `irony-mod-manager`

#### `home/modules/games-linux.nix` — Linux Games
- `bottles` → Wine prefix manager
- Flatpak: Sober (Roblox via Vinegar)

#### `home/modules/virtualisation.nix` — User Virtualisation
- `qemu-user` → QEMU user-mode emulation

#### `home/modules/niri.nix` — Niri WM Config
- `xwayland-satellite`, `wl-mirror`
- `services.hypridle` → Idle daemon

#### `home/modules/theme.nix` — User Theming
- `adwsteamgtk` → Adwaita Steam skin

#### `home/modules/shell.nix` — Shell (Noctalia)
- `programs.noctalia-shell` → Custom shell with plugins

#### `home/modules/nextcloud.nix` — Nextcloud
- rclone-based Nextcloud mount (systemd user service)

#### `home/modules/flatpak.nix` — Flatpak (HM)
- Flatpak remote configuration

#### `home/modules/services.nix` — User Services
- `services.mpris-proxy` → Bluetooth media control

---

## Recommendations for Further Reducing Package Count

### Already Done ✅
1. ~~**Replace GNOME with GDM-only + individual apps.**~~ ✅ Done — saved ~2000+ packages.
2. ~~**Remove CUDA.**~~ ✅ Done — saved ~400–600 packages.
3. ~~**Remove VirtualBox.**~~ ✅ Done — saved ~100–200 packages.

### Medium Impact (save 100–500 packages each)
4. **Drop Chromium** if LINE can work in Zen Browser, or use a PWA approach.
5. **Deduplicate fonts.** Fonts are declared in both `host/modules/common/theming.nix`
   and `home/modules/gui.nix`. Consolidate to one location.

### Low Impact (save 50–100 packages each)
6. **Audit nix-ld libraries.** The list in `compat.nix` is very large. Some may
   no longer be needed.
7. **Remove unused tools.** Audit CLI tools and formatters/LSPs in `ides.nix`
   for ones no longer used.
8. **Use Flatpak for heavy GUI apps** like LibreOffice or Kdenlive to keep them
   out of the Nix closure (trade-off: less reproducibility).
