# Development Guide

This guide provides detailed instructions for setting up a development environment and working on Reddit Desktop.

## Prerequisites

### Required
- **Node.js**: >= 22.12.0 (download from [nodejs.org](https://nodejs.org/))
- **npm**: Comes with Node.js (verify: `npm --version`)
- **Git**: For version control (download from [git-scm.com](https://git-scm.com/))

### Recommended
- **Visual Studio Code**: Great Electron development experience
- **ImageMagick**: For icon generation (`convert` command)
- **GNU Build Tools**: For native module compilation if needed

### Installation by OS

**Ubuntu/Debian:**
```bash
# Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# ImageMagick (optional but recommended)
sudo apt-get install -y imagemagick

# Git
sudo apt-get install -y git
```

**Kali Linux:**
```bash
# Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# ImageMagick (optional)
sudo apt-get install -y imagemagick

# Git
sudo apt-get install -y git
```

**Fedora/RHEL:**
```bash
# Node.js
sudo dnf install nodejs npm

# ImageMagick
sudo dnf install ImageMagick

# Git
sudo dnf install git
```

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/example/reddit-desktop.git
cd reddit-desktop
```

### 2. Run Setup Script

```bash
bash scripts/setup.sh
```

This will:
- Check for required tools
- Install npm dependencies
- Generate application icons
- Display next steps

### 3. Manual Setup (Alternative)

If the script doesn't work:

```bash
# Install dependencies
npm install

# Generate icons from SVG
bash scripts/generate-icons.sh
```

## Development Commands

### Running in Development Mode

```bash
npm run dev
```

This launches the application with:
- Logging enabled
- DevTools accessible (<kbd>Ctrl+Shift+I</kbd>)
- Error details displayed
- Hot reload on save (reload with <kbd>Ctrl+R</kbd>)

### Validating Code

```bash
npm run validate
```

Checks JavaScript syntax in:
- `src/main/main.js`
- `src/preload/preload.js`

### Building Packages

```bash
# All Linux packages (AppImage + .deb)
npm run package

# AppImage only
npm run build:appimage

# Debian package only
npm run build:deb

# Output: dist/
```

### Cleaning Build Output

```bash
npm run clean
```

## Project Structure

```
reddit-desktop/
├── src/
│   ├── main/
│   │   └── main.js              # Electron main process
│   │                             # - Window management
│   │                             # - Navigation policy
│   │                             # - Session configuration
│   │                             # - Menu creation
│   │
│   ├── preload/
│   │   └── preload.js           # Preload script
│   │                             # - Safe bridge to renderer
│   │                             # - Limited API exposure
│   │
│   └── assets/
│       ├── offline.html         # Error recovery page
│       ├── icons/
│       │   ├── reddit.svg       # Source icon
│       │   ├── 512.png          # Generated sizes
│       │   ├── 256.png
│       │   ├── 128.png
│       │   ├── 64.png
│       │   ├── 48.png
│       │   ├── 32.png
│       │   ├── 24.png
│       │   └── 16.png
│       └── ... (other assets)
│
├── scripts/
│   ├── setup.sh                 # Development setup
│   ├── generate-icons.sh        # Generate PNG icons
│   ├── after-install.sh         # .deb post-install
│   └── after-remove.sh          # .deb post-remove
│
├── package.json                 # Dependencies & scripts
├── electron-builder.yml         # Packaging configuration
│
├── README.md                    # User documentation
├── CONTRIBUTING.md              # Contributing guide
├── SECURITY.md                  # Security model
├── DEVELOPMENT.md               # This file
├── LICENSE                      # MIT License
└── .gitignore                   # Git ignore rules
```

## Key Files Explained

### `src/main/main.js` - Application Core

**Responsibilities:**
- Electron lifecycle management
- Window creation and configuration
- Navigation policy (allow Reddit URLs, open others externally)
- Session configuration (permissions, downloads, storage)
- Menu creation
- IPC communication

**Important Constants:**
```javascript
const APP_URL = 'https://www.reddit.com/';        // URL to load
const PARTITION = 'persist:reddit';               // Session storage
const REDDIT_HOSTS = new Set([...]);              // Allowed hosts
```

**Security Features:**
```javascript
contextIsolation: true        // Isolated JavaScript contexts
nodeIntegration: false        // No Node.js in renderer
sandbox: true                 // OS-level sandbox
webSecurity: true             // Standard browser security
```

### `src/preload/preload.js` - Safe Bridge

**Exposed API:**
```javascript
window.redditDesktop = {
  retry: () => { /* Retry loading Reddit */ },
  getAppVersion: () => { /* Return version string */ },
  getPlatform: () => { /* Return OS platform */ }
}
```

**NOT Exposed:**
- ❌ Node.js `require()`, `process`, `fs`
- ❌ Raw `ipcRenderer`
- ❌ File system access
- ❌ Shell execution

### `src/assets/offline.html` - Error Page

Displays when Reddit can't be reached:
- Shows error message
- Provides "Retry" button
- Offers "Open in Browser" option
- Includes troubleshooting info

### `electron-builder.yml` - Build Configuration

Defines packaging:
- Linux targets (AppImage, .deb)
- Icon paths
- Desktop entry metadata
- Package naming conventions

## Debugging

### Enable Logging

Run with logging enabled:
```bash
npm run dev
```

Console output will show:
- Electron lifecycle events
- IPC communication
- Navigation events
- Network requests

### DevTools

In development mode, open DevTools with <kbd>Ctrl+Shift+I</kbd>:
- Inspect HTML/CSS
- Check console for errors
- Debug JavaScript
- Monitor network requests
- View application storage

### Debugging from VS Code

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Electron Main",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/node_modules/.bin/electron",
      "args": ["."],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

Then run: <kbd>F5</kbd> to start debugging

### Common Issues

**"Reddit won't load"**
- Check network connection: `ping reddit.com`
- Check URL whitelist in main.js
- Enable logging: `npm run dev`
- Check DevTools console for errors

**"Icons not found"**
- Generate icons: `bash scripts/generate-icons.sh`
- Check `src/assets/icons/` directory
- ImageMagick required for generation

**"Build fails"**
- Clean build: `npm run clean`
- Reinstall deps: `rm -rf node_modules && npm install`
- Check Node.js version: `node --version`

## Making Changes

### Adding a New Feature

1. **Plan**: Think about the implementation
2. **Create branch**: `git checkout -b feature/my-feature`
3. **Implement**: Make your changes
4. **Test**: Run `npm run dev` and test thoroughly
5. **Validate**: Run `npm run validate`
6. **Commit**: `git commit -m "Add feature: description"`
7. **Push**: `git push origin feature/my-feature`
8. **PR**: Create pull request on GitHub

### Example: Adding a New Menu Item

**File: `src/main/main.js`**

In the `createMenu()` function:

```javascript
{
  label: 'File',
  submenu: [
    // ... existing items ...
    {
      label: 'New Tab',
      accelerator: 'CmdOrCtrl+T',
      click: () => {
        // Handle new tab action
      }
    }
  ]
}
```

### Example: Adding a New Keyboard Shortcut

Add to menu accelerator:
```javascript
{ role: 'reload', accelerator: 'CmdOrCtrl+R' }
```

Or handle in preload/main process:
```javascript
mainWindow.webContents.on('before-input-event', (event, input) => {
  if (input.control && input.key.toLowerCase() === 't') {
    // Handle Ctrl+T
  }
});
```

## Testing Your Changes

### Manual Testing

1. Run: `npm run dev`
2. Test your changes
3. Use keyboard shortcuts
4. Test external link opening
5. Check console for errors
6. Verify no security issues

### Build Testing

```bash
# Build packages
npm run package

# Install .deb
sudo apt install dist/reddit-desktop_1.0.0_amd64.deb

# Test AppImage
chmod +x dist/Reddit-Desktop-1.0.0-x86_64.AppImage
./dist/Reddit-Desktop-1.0.0-x86_64.AppImage
```

## Performance Tips

1. **Keep preload small** - Minimize exposed APIs
2. **Avoid blocking operations** - Don't freeze UI
3. **Cache efficiently** - Let Electron handle it
4. **Monitor memory** - Watch for leaks in DevTools
5. **Close resources** - Clean up listeners on close

## Security Checklist

Before committing:

- [ ] No `eval()` or `Function()` constructors
- [ ] No disabled security features
- [ ] Preload is minimal
- [ ] IPC channels are validated
- [ ] No hardcoded credentials
- [ ] All URLs are validated
- [ ] External links validated before opening
- [ ] No console.log of sensitive data

## Publishing

### Creating a Release

1. **Update version** in `package.json`
2. **Build**: `npm run package`
3. **Test packages**: Test both .deb and AppImage
4. **Create release** on GitHub
5. **Upload packages** to release
6. **Write release notes**

### Version Numbers

Use semantic versioning (MAJOR.MINOR.PATCH):
- **1.0.0** - Initial release
- **1.1.0** - New feature (backward compatible)
- **1.1.1** - Bug fix
- **2.0.0** - Breaking change

## Documentation

When making changes:
- Update README if user-facing
- Update SECURITY.md if security-related
- Add inline code comments
- Document new IPC channels
- Update this DEVELOPMENT.md if needed

## Resources

- [Electron Documentation](https://www.electronjs.org/docs)
- [Electron Security](https://www.electronjs.org/docs/tutorial/security)
- [electron-builder](https://www.electron.build/)
- [Node.js Documentation](https://nodejs.org/en/docs/)
- [Reddit Documentation](https://www.reddit.com/)

## Getting Help

1. **Check existing issues** - Might be answered already
2. **Search documentation** - README, SECURITY.md, this file
3. **Create an issue** - Describe problem clearly
4. **Ask in discussions** - For questions (if enabled)

## Code of Conduct

- Be respectful to other contributors
- Assume good intentions
- Focus on the code, not the person
- Help others learn

---

**Happy coding! 🚀**

For questions, open an issue or discussion on GitHub.
