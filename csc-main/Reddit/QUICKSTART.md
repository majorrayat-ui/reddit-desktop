# Quick Start Guide

Get Reddit Desktop up and running in minutes!

## For Users - Installation

### Ubuntu/Debian (Easiest)

```bash
# Download and install
wget https://github.com/example/reddit-desktop/releases/download/v1.0.0/reddit-desktop_1.0.0_amd64.deb
sudo apt install ./reddit-desktop_1.0.0_amd64.deb

# Launch from Applications menu or terminal
reddit-desktop
```

### Any Linux (AppImage - No Installation)

```bash
# Download and run
wget https://github.com/example/reddit-desktop/releases/download/v1.0.0/Reddit-Desktop-1.0.0-x86_64.AppImage
chmod +x Reddit-Desktop-1.0.0-x86_64.AppImage
./Reddit-Desktop-1.0.0-x86_64.AppImage
```

## For Developers - Setup

### 1. Clone and Install (2 minutes)

```bash
git clone https://github.com/example/reddit-desktop.git
cd reddit-desktop
bash scripts/setup.sh
```

### 2. Run in Development Mode (< 1 minute)

```bash
npm run dev
```

The application will launch with logging and DevTools enabled.

### 3. Make Changes and Reload

- Edit files in `src/`
- Press <kbd>Ctrl+R</kbd> to reload
- Press <kbd>Ctrl+Shift+I</kbd> to open DevTools

### 4. Build Packages (3-5 minutes)

```bash
npm run package
```

Output in `dist/`:
- `Reddit-Desktop-1.0.0-x86_64.AppImage`
- `reddit-desktop_1.0.0_amd64.deb`

## Common Tasks

### View Application Menu

Run `npm run dev`, then:

1. Right-click the Reddit window
2. Or use the menu bar at the top
3. Keyboard shortcut: <kbd>Alt</kbd> (shows menu bar)

### Create a New Window

While running `npm run dev`:
- Press <kbd>Ctrl+N</kbd>
- Or use File → New Reddit Window

### Open DevTools

In development mode (`npm run dev`):
- Press <kbd>Ctrl+Shift+I</kbd>
- Or right-click → Inspect

### Reload Reddit

- Press <kbd>Ctrl+R</kbd> - Reload
- Press <kbd>Ctrl+Shift+R</kbd> - Hard reload (clear cache)

### Test Navigation Shortcuts

| Key | Action |
|-----|--------|
| <kbd>Alt+Left</kbd> | Go back |
| <kbd>Alt+Right</kbd> | Go forward |
| <kbd>Alt+Home</kbd> | Go to Reddit home |
| <kbd>Ctrl+Plus</kbd> | Zoom in |
| <kbd>Ctrl+Minus</kbd> | Zoom out |
| <kbd>Ctrl+0</kbd> | Reset zoom |
| <kbd>F11</kbd> | Toggle fullscreen |

## Troubleshooting

### "Command not found: npm"

Install Node.js from [nodejs.org](https://nodejs.org/)

```bash
# Verify installation
node --version  # Should show v22.x.x or higher
npm --version   # Should show 10.x.x or higher
```

### "ImageMagick not found"

Optional but recommended for icon generation:

```bash
# Ubuntu/Debian
sudo apt-get install imagemagick

# Fedora
sudo dnf install ImageMagick

# Arch
sudo pacman -S imagemagick
```

### "Icons not generated"

Manually generate:

```bash
bash scripts/generate-icons.sh
```

### "Build fails"

Clean and retry:

```bash
npm run clean
npm install
npm run package
```

### "Application won't start"

Check prerequisites:

```bash
# Verify Node.js
node --version  # >= 22.12.0

# Verify dependencies installed
npm ls

# Try running with logging
npm run dev
```

## File Locations

**User Configuration:**
```
~/.config/Reddit/
├── window-state.json        # Window size/position
└── Partitions/
    └── persist:reddit/      # Reddit session data
        ├── Cookies
        ├── Local Storage
        └── ...
```

**Project Files (Development):**
```
reddit-desktop/
├── src/main/main.js         # Main application
├── src/preload/preload.js   # Security bridge
├── src/assets/              # Icons, error page
└── dist/                    # Build output
```

## Testing the Build

After running `npm run package`:

### Test AppImage

```bash
# Make executable (if not already)
chmod +x dist/Reddit-Desktop-1.0.0-x86_64.AppImage

# Run it
./dist/Reddit-Desktop-1.0.0-x86_64.AppImage
```

### Test Debian Package

```bash
# Install
sudo apt install ./dist/reddit-desktop_1.0.0_amd64.deb

# Launch from Applications menu
# Or terminal:
reddit-desktop

# Uninstall when done
sudo apt remove reddit-desktop
```

## Next Steps

- **Read the README**: Full documentation at [README.md](README.md)
- **Learn Development**: See [DEVELOPMENT.md](DEVELOPMENT.md)
- **Understand Security**: Check [SECURITY.md](SECURITY.md)
- **Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md)

## Getting Help

1. **Documentation**: Start with README.md
2. **Issues**: Check [GitHub Issues](https://github.com/example/reddit-desktop/issues)
3. **Questions**: Create a Discussion on GitHub

## Quick Reference

**Running the App:**
```bash
npm run dev              # Development mode with logging
./dist/*.AppImage       # Run AppImage directly
reddit-desktop          # After .deb installation
```

**Building:**
```bash
npm run package         # Build all packages
npm run build:appimage  # AppImage only
npm run build:deb       # Debian package only
```

**Cleaning:**
```bash
npm run clean           # Remove build output
rm -rf ~/.config/Reddit # Reset configuration
```

**Keyboard Shortcuts (Development):**
| Keys | Purpose |
|------|---------|
| <kbd>Ctrl+Shift+I</kbd> | Open DevTools |
| <kbd>Ctrl+R</kbd> | Reload app |
| <kbd>F12</kbd> | Toggle DevTools (in DevTools) |

---

**That's it! You're ready to go! 🚀**

For more details, see:
- [README.md](README.md) - Full documentation
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide
- [SECURITY.md](SECURITY.md) - Security model
