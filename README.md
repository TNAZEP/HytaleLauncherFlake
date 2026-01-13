<div align="center">

# ‼️‼️‼️ Disclaimer ‼️‼️‼️
This flake was created before the launch of the game, it works perfectly for the launcher, but I give no guarantees there wont be issues upon game launch. As the game releases I will fix any issues that might occur as fast as possible.

</div>

# HytaleLauncherFlake

A flake for easy use of the Hytale Launcher on NixOS. The launcher is automatically downloaded from Hytale's official servers on first run.

## Installation

### Run directly without installing

```bash
nix run github:TNAZEP/HytaleLauncherFlake
```

Or from a local clone:

```bash
nix run .
```

### Install to your profile

```bash
nix profile install github:TNAZEP/HytaleLauncherFlake
```

### Add to your NixOS configuration

Add the flake to your inputs in `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hytale-launcher.url = "github:TNAZEP/HytaleLauncherFlake;
  };

  outputs = { self, nixpkgs, hytale-launcher, ... }@inputs: {
    # Your configuration here
  };
}
```

Then add the package to your `environment.systemPackages` or home-manager packages:

```nix
environment.systemPackages = [
  inputs.hytale-launcher.packages.${pkgs.system}.default
];
```

### Add to Home Manager

```nix
home.packages = [
  inputs.hytale-launcher.packages.${pkgs.system}.default
];
```

## How It Works

This flake:

1. **Creates an FHS environment** with all required dependencies (GTK3, WebKit, etc.)
2. **Downloads** the launcher on first run from Hytale's official servers
3. **Auto-updates** - the launcher manages its own updates from `~/.local/share/hytale-launcher/`

No manual hash updates needed - the launcher is always fetched fresh on first install!

## Dependencies

This flake automatically provides the following dependencies:
- GTK3
- WebKit2GTK 4.1
- GLib
- GDK Pixbuf
- libsoup 3
- Cairo / Pango
- OpenSSL
- X11/Wayland libraries
- Vulkan/Mesa
- PulseAudio / ALSA
- And more...

## Reinstalling / Updating

To force a fresh download of the launcher:

```bash
rm -rf ~/.local/share/hytale-launcher
hytale-launcher
```

## Troubleshooting

If you encounter display issues, try running with different environment variables:

```bash
# Force X11 backend
GDK_BACKEND=x11 hytale-launcher

# Force Wayland backend
GDK_BACKEND=wayland hytale-launcher
```

## License

The Hytale Launcher is proprietary software by Hypixel Studios. This flake only provides packaging for NixOS.
