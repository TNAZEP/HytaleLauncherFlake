{
  description = "Hytale Launcher - packaged for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Runtime dependencies for the Tauri/WebKit-based launcher
        runtimeDeps = with pkgs; [
          glib
          gtk3
          webkitgtk_4_1
          gdk-pixbuf
          libsoup_3
          cairo
          pango
          harfbuzz
          atk
          openssl
          zlib
        ];

        # FHS environment that downloads launcher at runtime
        hytale-launcher = pkgs.buildFHSEnv {
          name = "hytale-launcher";

          targetPkgs = pkgs: runtimeDeps ++ (with pkgs; [
            # Additional runtime deps
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libxcb
            libxkbcommon
            mesa
            vulkan-loader
            alsa-lib
            pulseaudio
            dbus
            gsettings-desktop-schemas
            glib
            hicolor-icon-theme
            adwaita-icon-theme
            # Tools for downloading and patching
            curl
            unzip
            patchelf
          ]);

          profile = ''
            export GDK_BACKEND=x11
            export WEBKIT_DISABLE_COMPOSITING_MODE=1
            export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS"
          '';

          runScript = pkgs.writeShellScript "hytale-launcher-wrapper" ''
            set -e

            LAUNCHER_DIR="$HOME/.local/share/hytale-launcher"
            LAUNCHER_BIN="$LAUNCHER_DIR/hytale-launcher"
            DOWNLOAD_URL="https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.zip"

            # Create launcher directory
            mkdir -p "$LAUNCHER_DIR"

            # Download and set up launcher if it doesn't exist
            if [ ! -f "$LAUNCHER_BIN" ]; then
              echo "Downloading Hytale Launcher..."
              TEMP_DIR=$(mktemp -d)
              trap "rm -rf $TEMP_DIR" EXIT

              curl -L -o "$TEMP_DIR/launcher.zip" "$DOWNLOAD_URL"
              unzip -o "$TEMP_DIR/launcher.zip" -d "$TEMP_DIR"
              mv "$TEMP_DIR/hytale-launcher" "$LAUNCHER_BIN"
              chmod +x "$LAUNCHER_BIN"

              echo "Hytale Launcher installed successfully!"
            fi

            # Run from mutable location (allows self-updates)
            cd "$LAUNCHER_DIR"
            exec "$LAUNCHER_BIN" "$@"
          '';

          meta = with pkgs.lib; {
            description = "Hytale Game Launcher";
            homepage = "https://hytale.com";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
            mainProgram = "hytale-launcher";
          };
        };

      in {
        packages = {
          inherit hytale-launcher;
          default = hytale-launcher;
        };

        apps = rec {
          hytale-launcher = flake-utils.lib.mkApp {
            drv = self.packages.${system}.hytale-launcher;
          };
          default = hytale-launcher;
        };
      }
    );
}
