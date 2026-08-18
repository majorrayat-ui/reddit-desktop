# Reddit Desktop - Linux Electron Wrapper

A polished, production-quality Electron-based desktop application that provides a dedicated, native-feeling desktop experience for Reddit on Ubuntu Linux and Kali Linux.

## Project Overview

Reddit Desktop is an **unofficial Electron wrapper** around Reddit's official website. This application is not affiliated with, endorsed by, or developed by Reddit, Inc.

The wrapper provides:

- Native Linux desktop application
- Session persistence (automatic login on reopening)
- System integration (menu bar, notifications, downloads)
- Keyboard shortcuts and navigation controls
- Multiple window support
- External link handling
- Professional error handling and recovery

The application loads [https://www.reddit.com](https://www.reddit.com/) inside a secure Electron container, preserving Reddit's full functionality including:

- Home and Popular feeds
- Community browsing and subscriptions
- Posts, comments, and voting
- User profiles and accounts
- Search functionality
- Create posts and comments
- Direct messages and notifications
- All Reddit features available on the web

## Architecture

The application follows a clean, secure architecture:

```
src/
├── main/
│   └── main.js              # Electron main process
├── preload/
│   └── preload.js           # Safe preload bridge
└── assets/
    ├── offline.html         # Error recovery page
    └── icons/               # Application icons
```

### Main Process (`main.js`)

Responsible for:

- Application lifecycle management
- Window creation and management
- Reddit website loading
- Navigation policy enforcement
- Session persistence
- Session configuration (permissions, downloads)
- Application menus
- IPC communication

### Preload Script (`preload.js`)

Provides a minimal, safe bridge to the renderer with read-only access to:

- App version
- Platform information
- Retry functionality

**Security**: Does NOT expose:

- Node.js APIs
- File system access
- Shell execution
- Arbitrary IPC commands
- Process environment

### Session Management

- **Session Type**: Persistent (survives application restarts)
- **Partition**: `persist:reddit`
- **Storage**: Cookies, local storage, IndexedDB
- **Default Behavior**: Maintains Reddit login state between launches

### Navigation Policy

**Allowed Internal Navigation:**

- reddit.com
- www.reddit.com  
- old.reddit.com
- new.reddit.com
- All legitimate Reddit subdomains

**External Links:**

- Automatically opened in the system default browser
- Examples: GitHub, YouTube, external articles
- Uses `Electron.shell.openExternal()`

### Security Model

- ✅ `nodeIntegration: false` - No Node.js in renderer
- ✅ `contextIsolation: true` - Isolated JavaScript contexts
- ✅ `sandbox: true` - Renderer process sandboxed
- ✅ `webSecurity: true` - Standard web security enforced
- ✅ Validated IPC channels - Explicit command whitelist
- ✅ Safe URL handling - Protocol validation

## Installation

### Ubuntu Linux

#### Option 1: Debian Package (.deb)

```bash
# Download the latest .deb package
wget https://github.com/example/reddit-desktop/releases/download/v1.0.0/reddit-desktop_1.0.0_amd64.deb

# Install
sudo apt install ./reddit-desktop_1.0.0_amd64.deb

# Launch from Applications menu or run:
reddit-desktop
```

**Uninstall:**

```bash
sudo apt remove reddit-desktop
```

#### Option 2: AppImage (No Installation Required)

```bash
# Download the AppImage
wget https://github.com/example/reddit-desktop/releases/download/v1.0.0/Reddit-Desktop-1.0.0-x86_64.AppImage

# Make executable
chmod +x Reddit-Desktop-1.0.0-x86_64.AppImage

# Run directly
./Reddit-Desktop-1.0.0-x86_64.AppImage
```

**Create a Desktop Shortcut:**

```bash
# The AppImage can be made a desktop application entry:
mkdir -p ~/.local/share/applications
ln -s /path/to/Reddit-Desktop-1.0.0-x86_64.AppImage ~/.local/share/applications/reddit-desktop.desktop
```

### Kali Linux

Reddit Desktop works on Kali Linux using the same installation methods as Ubuntu:

```bash
# Using AppImage (recommended for Kali)
chmod +x Reddit-Desktop-1.0.0-x86_64.AppImage
./Reddit-Desktop-1.0.0-x86_64.AppImage
```

Or install the `.deb` package the same way as Ubuntu.

## Usage

### Launching the Application

**From Application Menu:**
- Ubuntu GNOME: Click "Show Applications" and search for "Reddit"
- KDE Plasma: Application Launcher → Search "Reddit"
- XFCE: Applications Menu → Network → Reddit

**From Terminal:**

```bash
reddit-desktop
```

**From AppImage:**

```bash
/path/to/Reddit-Desktop-1.0.0-x86_64.AppImage
```

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| <kbd>Ctrl+N</kbd> | New Reddit Window |
| <kbd>Ctrl+R</kbd> | Reload Page |
| <kbd>Ctrl+Shift+R</kbd> | Hard Reload (clear cache) |
| <kbd>Alt+Left</kbd> | Back |
| <kbd>Alt+Right</kbd> | Forward |
| <kbd>Alt+Home</kbd> | Reddit Home |
| <kbd>Ctrl+L</kbd> | Focus address bar (if available) |
| <kbd>Ctrl+Plus</kbd> | Zoom In |
| <kbd>Ctrl+Minus</kbd> | Zoom Out |
| <kbd>Ctrl+0</kbd> | Reset Zoom |
| <kbd>F11</kbd> | Toggle Fullscreen |
| <kbd>Ctrl+Shift+I</kbd> | Developer Tools (dev mode only) |
| <kbd>Ctrl+W</kbd> | Close Window |
| <kbd>Ctrl+Q</kbd> | Quit Application |

### Application Menu

**File**
- New Reddit Window
- Open Reddit
- Close Window
- Quit

**Edit**
- Undo, Redo
- Cut, Copy, Paste
- Select All

**View**
- Reload
- Force Reload
- Zoom In/Out/Reset
- Toggle Fullscreen
- Toggle Developer Tools (dev mode only)

**Navigate**
- Back/Forward
- Home

**Help**
- Reddit Website
- Reddit Help
- About Reddit Desktop

### Multi-Window Support

Create multiple Reddit windows with <kbd>Ctrl+N</kbd> or via the File menu. Each window uses the same persistent session, so you'll remain logged in across all windows.

## Configuration

### Window State

The application automatically remembers your last window size and position. These are stored in:

```
~/.config/Reddit/window-state.json
```

To reset window position and size, delete this file.

### Session Data

Reddit's session data (login, preferences, etc.) is stored by Electron in:

```
~/.config/Reddit/Partitions/persist:reddit/
```

This directory contains:

- Cookies
- Local storage
- IndexedDB data
- Cache files

## Troubleshooting

### Reddit Won't Load

1. Check your internet connection
2. Click "Retry" on the error page
3. Try reloading with <kbd>Ctrl+Shift+R</kbd>
4. Restart the application
5. Check if [reddit.com](https://www.reddit.com) is accessible in your web browser

### I'm Logged Out When I Restart

This is unexpected. By default, the application maintains your session. If you're logging out:

1. Try clearing and restarting: Delete `~/.config/Reddit/Partitions/persist:reddit/`
2. Log in again
3. Your session should persist on future restarts

### Application Crashes on Startup

1. Check for the latest version
2. Try removing the configuration directory:
   ```bash
   rm -rf ~/.config/Reddit/
   ```
3. Restart the application

### External Links Not Opening

Ensure your system has a default web browser set:

```bash
xdg-settings set default-web-browser firefox.desktop  # or your browser
```

### Performance Issues

1. Try a hard reload: <kbd>Ctrl+Shift+R</kbd>
2. Close extra windows
3. Clear cache: Delete `~/.config/Reddit/Cache/`
4. Restart the application

## Development

### Prerequisites

- Node.js >= 22.12.0
- npm
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/example/reddit-desktop.git
cd reddit-desktop

# Install dependencies
npm install

# Run in development mode
npm run dev
```

### Development Mode Features

- Developer Tools enabled with <kbd>Ctrl+Shift+I</kbd>
- Console logging enabled
- Verbose error messages

### Building

```bash
# Validate code
npm run validate

# Build Linux packages (AppImage + .deb)
npm run package:linux

# Build only AppImage
npm run build -- --linux AppImage

# Build only .deb
npm run build -- --linux deb

# Output location
dist/
├── Reddit-Desktop-1.0.0-x86_64.AppImage
└── reddit-desktop_1.0.0_amd64.deb
```

### Project Structure

```
reddit-desktop/
├── src/
│   ├── main/
│   │   └── main.js                 # Main process
│   ├── preload/
│   │   └── preload.js              # Preload script
│   └── assets/
│       ├── offline.html            # Error page
│       └── icons/                  # Application icons
│           ├── reddit.svg          # Source icon
│           └── *.png               # Generated PNG icons
├── scripts/
│   ├── after-install.sh            # .deb post-install
│   └── after-remove.sh             # .deb post-remove
├── package.json                     # Dependencies & build config
├── electron-builder.yml            # Build configuration
└── README.md                        # This file
```

## Reddit Compatibility

This application is compatible with Reddit's current web interface. It supports:

- ✅ All feed types (Home, Popular, All)
- ✅ Subreddit browsing and subscriptions
- ✅ Posts, comments, voting
- ✅ User profiles
- ✅ Search
- ✅ Direct messages
- ✅ Notifications
- ✅ Creating posts/comments
- ✅ Media and embeds (videos, images, gifs)
- ✅ Awards
- ✅ Saved posts
- ✅ History
- ✅ Moderation features

**Known Limitations:**

- Some Reddit features that rely on deep mobile integration may have limited support
- Reddit's design may change without notice; this application will continue to work with future Reddit layouts

## Privacy & Data

**What This Application Does NOT Do:**

- ❌ Does not collect your browsing history
- ❌ Does not send data to third-party servers
- ❌ Does not track usage statistics
- ❌ Does not modify or scrape Reddit's content
- ❌ Does not intercept your Reddit credentials
- ❌ Does not analyze your data

**What This Application Does:**

- Loads Reddit's official website (HTTPS)
- Stores your Reddit session locally (same as any browser)
- Caches web resources normally (like any browser)
- Stores your application preferences locally

**Session Data:**

Your Reddit session (login credentials, preferences, etc.) is managed entirely by Reddit and stored locally on your computer through standard browser mechanisms. This application does not access, modify, or transmit this data.

## License

MIT License - See LICENSE file for details

**Important:** This project is independent and unofficial. Reddit is a trademark of Reddit, Inc. This application simply provides a native desktop wrapper around Reddit's public website.

## Attribution

Reddit Desktop is inspired by similar Electron wrappers and follows Electron best practices for security, performance, and user experience.

## Support

For issues, feature requests, or contributions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search existing GitHub issues
3. Create a new issue with details about your system and the problem

## Legal Disclaimers

- **Not Official**: This application is not developed by, endorsed by, or affiliated with Reddit, Inc.
- **Third-Party Wrapper**: Reddit Desktop is a third-party Electron wrapper around Reddit's official website.
- **Use Responsibly**: Comply with Reddit's Terms of Service and community guidelines.
- **No Warranty**: Provided as-is without warranty. Use at your own risk.

## Frequently Asked Questions

### Is this the official Reddit desktop application?

No. Reddit Desktop is an unofficial third-party Electron wrapper. It is not developed or endorsed by Reddit, Inc. It simply provides a native-feeling desktop application shell around Reddit's official website.

### Will this work if Reddit changes their website?

Yes. Since this application loads Reddit's actual website, any changes Reddit makes will automatically be reflected in the application. The wrapper layer remains functional regardless of Reddit's design changes.

### Can I open Reddit URLs directly?

If you set this application as the default handler for reddit.com URLs, you can launch Reddit directly from other applications. However, this is not recommended if you want your default browser to handle Reddit links.

### How do I uninstall Reddit Desktop?

**For .deb package:**
```bash
sudo apt remove reddit-desktop
```

**For AppImage:**
Simply delete the AppImage file. Optionally, also remove configuration:
```bash
rm -rf ~/.config/Reddit/
```

### Does this work offline?

No. Reddit Desktop requires an internet connection to display Reddit content. When offline, you'll see an error page with connection troubleshooting options.

### Can I use this with Reddit Premium/Gold?

Yes! You can log in with any Reddit account, including Premium accounts. All features work normally.

### What about cookies and privacy?

Cookies and session data are stored locally on your computer (in `~/.config/Reddit/`). This application does not send any data to third-party servers or analytics services.

### Why does the application exit when I close all windows?

This is standard desktop application behavior on Linux. Closing all windows quits the application. To keep the application running in the background, you would need to minimize rather than close the window.

## Changelog

### Version 1.0.0 (Initial Release)

- ✨ Electron-based Reddit desktop application
- ✨ Session persistence and automatic login
- ✨ Multi-window support
- ✨ Keyboard shortcuts and native menus
- ✨ External link handling
- ✨ Download support
- ✨ Dark theme support
- ✨ Linux AppImage and .deb packaging
- ✨ Ubuntu and Kali Linux support

---

**Made with ❤️ for Linux users who love Reddit**
