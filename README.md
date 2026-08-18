# 🚀 LINUX-DESKTOP-APPS

A collection of Linux desktop applications including Reddit Desktop, streaming apps, and development tools.

---

## 📌 Featured Project: Reddit Desktop

### 🎯 About
A native Reddit desktop application for Linux, built with Electron. Full Reddit functionality with session persistence, keyboard shortcuts, and offline error handling.

### ⚡ Quick Installation

**One-line installation (works on any Linux distribution):**

```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```

**One-line uninstallation:**

```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash
```

### ✨ Features
- 🌐 Full Reddit website access via native desktop wrapper
- 💾 Session persistence (saves your login)
- ⌨️ Keyboard shortcuts for quick navigation
- 🔒 Enterprise-grade security hardening
- 📱 Works on any Linux distribution
- 🖥️ Professional desktop integration

### 🔧 System Requirements
- **OS**: Any Linux distribution (Ubuntu, Debian, Fedora, Arch, Kali, etc.)
- **Architecture**: 64-bit (x86_64)
- **Dependencies**: FUSE (for AppImage), or use .deb package

### 📦 Installation Methods

#### Method 1: One-Liner (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```
- Automatic download and installation
- Creates desktop launcher
- Available in applications menu

#### Method 2: Manual AppImage Download
1. Visit: https://github.com/majorrayat-ui/reddit-desktop/releases/tag/v1.0.0
2. Download `Reddit-Desktop-1.0.0-x86_64.AppImage`
3. Make executable: `chmod +x Reddit-Desktop-1.0.0-x86_64.AppImage`
4. Run: `./Reddit-Desktop-1.0.0-x86_64.AppImage`

#### Method 3: Debian/Ubuntu
1. Download from: https://github.com/majorrayat-ui/reddit-desktop/releases/tag/v1.0.0
2. Install: `sudo apt install ./reddit-desktop_1.0.0_amd64.deb`

### ⌨️ Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| Ctrl+N | New window |
| Ctrl+R | Reload |
| Ctrl+Shift+R | Hard reload |
| Alt+Left | Back |
| Alt+Right | Forward |
| Ctrl+Q | Quit |
| F11 | Fullscreen |
| Ctrl+Plus | Zoom in |
| Ctrl+Minus | Zoom out |

### 🗑️ Uninstallation
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/uninstall.sh | bash
```

Or manually:
```bash
rm ~/.local/bin/reddit-desktop
rm ~/.local/share/applications/reddit-desktop.desktop
rm -rf ~/.config/Reddit
```

### 📊 Package Information
- **Version**: 1.0.0
- **Electron**: 43.3.0
- **AppImage Size**: 123 MB
- **Debian Package Size**: 84 MB
- **Platform**: Linux (x86_64)

### 🔗 Repository & Links
- **GitHub**: https://github.com/majorrayat-ui/reddit-desktop
- **Release**: https://github.com/majorrayat-ui/reddit-desktop/releases/tag/v1.0.0
- **License**: MIT

### 🤝 Contributing
See [CONTRIBUTING.md](./csc-main/Reddit/CONTRIBUTING.md) for guidelines.

### 📝 Documentation
- [Installation Instructions](./csc-main/Reddit/README.md)
- [Development Guide](./csc-main/Reddit/DEVELOPMENT.md)
- [Security Model](./csc-main/Reddit/SECURITY.md)
- [Getting Started](./csc-main/Reddit/GETTING_STARTED.md)

---

## 📂 Repository Structure

```
LINUX-DESKTOP-APPS/
├── install.sh                    # Universal Reddit Desktop installer
├── uninstall.sh                  # Universal Reddit Desktop uninstaller
├── README.md                     # This file
├── csc-main/
│   ├── Reddit/                   # Reddit Desktop Electron app (MAIN PROJECT)
│   │   ├── src/
│   │   │   ├── main/main.js      # Electron main process
│   │   │   ├── preload/preload.js # IPC bridge
│   │   │   └── assets/
│   │   │       ├── offline.html  # Error page
│   │   │       └── icons/        # Application icons
│   │   ├── scripts/              # Build automation
│   │   ├── dist/                 # Built packages
│   │   ├── package.json          # Dependencies
│   │   ├── electron-builder.yml  # Build config
│   │   ├── README.md             # Project readme
│   │   ├── DEVELOPMENT.md        # Dev guide
│   │   ├── SECURITY.md           # Security docs
│   │   └── CONTRIBUTING.md       # Contributing guide
│   │
│   ├── Streaming-Apps/           # Streaming app wrappers
│   │   ├── Netflix/
│   │   ├── PrimeVideo/
│   │   ├── AppleTV/
│   │   ├── Crunchyroll/
│   │   ├── JioHotstar/
│   │   └── MXPlayer/
│   │
│   ├── MICROSOFT-DESKTOP-APPS/   # Microsoft app wrappers
│   │   ├── Teams/
│   │   ├── Outlook/
│   │   ├── PowerBI/
│   │   └── Whiteboard/
│   │
│   ├── Top-10-AI-Developer-Apps/ # AI/Dev tools
│   │   ├── Jupyter/
│   │   ├── Kaggle/
│   │   ├── HuggingFace/
│   │   ├── LeetCode/
│   │   └── More...
│   │
│   └── scripts/                  # Global build scripts
│
└── .git/                          # Git repository
```

---

## 🎯 Quick Start

### For End Users
Just run this command:
```bash
curl -fsSL https://raw.githubusercontent.com/majorrayat-ui/reddit-desktop/main/install.sh | bash
```

### For Developers
```bash
cd csc-main/Reddit
npm install
npm run dev          # Start development
npm run build        # Build packages
npm run validate     # Validate code
```

---

## ✅ Verification Checklist

Before deploying, verify:
- ✅ All source files present and valid
- ✅ Installation scripts executable and working
- ✅ GitHub URLs accessible and functional
- ✅ AppImage downloads successfully
- ✅ Desktop launcher creates correctly
- ✅ Uninstallation removes all files
- ✅ No console errors during installation
- ✅ Application launches without issues

---

## 🔐 Security Notes

Reddit Desktop includes:
- ✅ Electron context isolation
- ✅ Disabled node integration
- ✅ Sandboxed renderer process
- ✅ URL validation and whitelisting
- ✅ Session partitioning for isolation
- ✅ Content security policy headers

See [SECURITY.md](./csc-main/Reddit/SECURITY.md) for details.

---

## 📞 Support & Issues

- **Bug Reports**: https://github.com/majorrayat-ui/reddit-desktop/issues
- **Feature Requests**: https://github.com/majorrayat-ui/reddit-desktop/issues
- **Discussions**: https://github.com/majorrayat-ui/reddit-desktop/discussions

---

## ⚖️ License

Reddit Desktop is licensed under the MIT License. See [LICENSE](./csc-main/Reddit/LICENSE) for details.

**Disclaimer**: This is an unofficial Electron wrapper for Reddit's website. Not affiliated with or endorsed by Reddit, Inc.

---

## 🎉 What's New (v1.0.0)

✨ Initial release with:
- Full Reddit website access
- Universal Linux support (all distributions)
- Session persistence
- Keyboard shortcuts
- Offline error handling
- Professional desktop integration
- Security-hardened configuration

---

**Last Updated**: August 18, 2024  
**Status**: ✅ Production Ready  
**Version**: 1.0.0
