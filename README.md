# HytaleLauncherFlake

A flake for easy use of the Hytale Launcher on NixOS.

## Installation

### Run directly without installing

```bash
nix run github:YOUR_USERNAME/HytaleLauncherFlake
```

Or from a local clone:

```bash
nix run .
```

### Install to your profile

```bash
nix profile install github:YOUR_USERNAME/HytaleLauncherFlake
```

### Add to your NixOS configuration

Add the flake to your inputs in `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hytale-launcher.url = "github:YOUR_USERNAME/HytaleLauncherFlake";
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

## Dependencies

This flake automatically handles the following dependencies:
- GTK3
- WebKit2GTK 4.1
- GLib
- GDK Pixbuf
- libsoup 3
- Cairo
- Pango
- OpenSSL
- And more...

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
