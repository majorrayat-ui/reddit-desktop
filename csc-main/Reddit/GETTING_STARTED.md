# Getting Started with Reddit Desktop

Welcome! This guide will help you get Reddit Desktop up and running in minutes.

## 📍 What You Have

A complete, production-ready Electron wrapper for Reddit with:

- ✅ Full Reddit website functionality
- ✅ Native Linux desktop experience
- ✅ Session persistence
- ✅ Multiple window support
- ✅ Professional error handling
- ✅ Comprehensive security measures
- ✅ AppImage and .deb packaging
- ✅ Complete documentation

## 🚀 Quick Start (< 5 minutes)

### Step 1: Install Dependencies

```bash
cd /home/simarsinghrayat/LINUX-DESKTOP-APPS/csc-main/Reddit
npm install
```

**What this does**: Downloads Node.js packages (Electron, electron-builder)

**Time**: ~1-2 minutes (depends on internet speed)

### Step 2: Generate Application Icons

```bash
bash scripts/generate-icons.sh
```

**What this does**: Creates PNG icons from the SVG source (requires ImageMagick)

**Note**: If ImageMagick is not installed, the script will tell you how to install it

**Time**: ~30 seconds

### Step 3: Run in Development Mode

```bash
npm run dev
```

**What this does**:
- Launches the application with Reddit loaded
- Enables logging to console
- Enables DevTools (Ctrl+Shift+I)
- Allows you to test the application

**Time**: ~5-10 seconds to launch

### Step 4: Test the Application

While running, try these:

| Test | How |
|------|-----|
| Load Reddit | Should load automatically |
| Navigate | Click subreddits or use Alt+Left/Right |
| Zoom | Try Ctrl+Plus, Ctrl+Minus, Ctrl+0 |
| Fullscreen | Press F11 |
| Developer Tools | Press Ctrl+Shift+I |
| New Window | Press Ctrl+N |
| Reload | Press Ctrl+R |

### Step 5: Stop the Application

- Click the window close button, or
- Press Ctrl+Q

---

## 📦 Build Packages (< 5 minutes)

Once you're satisfied with testing, build distributable packages:

```bash
npm run package
```

**What this does**:
- Creates AppImage (universal Linux format)
- Creates .deb package (Ubuntu/Debian/Kali)
- Places files in `dist/` directory

**Output**:
```
dist/
├── Reddit-Desktop-1.0.0-x86_64.AppImage    (universal)
└── reddit-desktop_1.0.0_amd64.deb          (Ubuntu/Kali)
```

**Time**: ~2-3 minutes

---

## 🧪 Test the Packages

### Test AppImage

```bash
# Make it executable (if needed)
chmod +x dist/Reddit-Desktop-1.0.0-x86_64.AppImage

# Run it
./dist/Reddit-Desktop-1.0.0-x86_64.AppImage
```

### Test .deb Package

```bash
# Install
sudo apt install dist/reddit-desktop_1.0.0_amd64.deb

# Launch from Applications menu or terminal
reddit-desktop

# Test it works, then uninstall
sudo apt remove reddit-desktop
```

---

## 📚 Documentation

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [FILE_MANIFEST.md](FILE_MANIFEST.md) | Overview of all files | 5 min |
| [QUICKSTART.md](QUICKSTART.md) | Quick reference | 5 min |
| [README.md](README.md) | Complete guide | 20 min |
| [DEVELOPMENT.md](DEVELOPMENT.md) | For developers | 25 min |
| [SECURITY.md](SECURITY.md) | Security model | 15 min |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contributing code | 15 min |

**Recommended Reading Order**:
1. This file (you are here)
2. [QUICKSTART.md](QUICKSTART.md)
3. [README.md](README.md)

---

## 🎯 Common Tasks

### Launch the Application

**Development Mode**:
```bash
npm run dev
```

**From AppImage**:
```bash
./dist/Reddit-Desktop-1.0.0-x86_64.AppImage
```

**From .deb Installation**:
```bash
reddit-desktop
```

### View Keyboard Shortcuts

While running `npm run dev`, press Alt to show menu bar and explore shortcuts

**Essential Shortcuts**:
- Ctrl+N - New window
- Ctrl+R - Reload
- Alt+Left - Back
- Alt+Right - Forward
- Ctrl+Q - Quit
- F11 - Fullscreen

### Open Developer Tools

While running `npm run dev`:
```
Press: Ctrl+Shift+I
```

This shows:
- Console (error messages)
- Network tab (see requests)
- Inspector (view HTML)
- Storage (cookies, local storage)

### Check for Issues

If something doesn't work:

1. **Run with logging**:
   ```bash
   npm run dev
   ```

2. **Open DevTools** (Ctrl+Shift+I)

3. **Check Console tab** for error messages

4. **See [Troubleshooting](#troubleshooting) below**

---

## ⚙️ Configuration

### Window Persistence

Your window size and position are automatically saved to:
```
~/.config/Reddit/window-state.json
```

To reset:
```bash
rm ~/.config/Reddit/window-state.json
```

Then restart the application.

### Reddit Session Data

Your Reddit login and settings are stored in:
```
~/.config/Reddit/Partitions/persist:reddit/
```

This is normal and expected - it's how browsers work.

To clear everything:
```bash
rm -rf ~/.config/Reddit/
```

Then restart and log in again.

---

## 🔧 Development Workflow

### Making Changes

1. **Edit source files** in `src/` directory
2. **Reload application** with Ctrl+R
3. **Test your changes**
4. **Check for errors** in DevTools console
5. **Repeat until satisfied**

### File Structure

```
src/
├── main/main.js          ← Main application logic
├── preload/preload.js    ← Safe bridge to Reddit
└── assets/
    ├── offline.html      ← Error page
    └── icons/            ← Application icons
```

**When to restart** (instead of just reloading):
- Changes to `main.js`
- Changing security settings
- Changing menu structure

**Full restart**: Kill the app and run `npm run dev` again

### Validating Code

```bash
npm run validate
```

Checks JavaScript syntax in main files.

---

## 📋 Troubleshooting

### "npm: command not found"

**Solution**: Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### "imagemagick: command not found"

**Solution**: Install ImageMagick (optional but recommended)
```bash
sudo apt-get install imagemagick
```

Then run:
```bash
bash scripts/generate-icons.sh
```

### "Reddit won't load"

**Check**:
1. Is your internet working?
2. Can you access reddit.com in a browser?
3. Check DevTools console for errors

**Fix**:
1. Reload with Ctrl+R
2. Try hard reload with Ctrl+Shift+R
3. Restart the application
4. Check your connection

### "Build fails"

**Clean rebuild**:
```bash
npm run clean
npm install
npm run package
```

### "Application crashes on startup"

**Reset configuration**:
```bash
rm -rf ~/.config/Reddit/
npm run dev
```

### "Keyboard shortcuts don't work"

1. Make sure application is focused (click the window)
2. Try disabling browser extensions (if in browser)
3. Check if another app is using the shortcut

---

## ✨ Features Overview

### What Works

✅ **Reddit Access**
- All feeds (Home, Popular, All)
- Subreddit browsing
- Posts and comments
- User profiles
- Search
- Voting, saving, awards
- Creating posts/comments
- Direct messages
- Notifications

✅ **Desktop Features**
- Multiple windows
- Back/forward navigation
- Zoom in/out
- Fullscreen
- Download support
- External link handling
- Professional error recovery
- Keyboard shortcuts

✅ **System Integration**
- Application launcher integration
- .deb package installation
- AppImage portable format
- Window state persistence
- Native menus

### What Doesn't Work

❌ **Deliberately Not Implemented**
- This application does NOT:
  - Recreate Reddit's interface
  - Scrape Reddit's content
  - Use undocumented APIs
  - Require root privileges
  - Collect personal data
  - Send telemetry

---

## 🔒 Security

This application:

✅ **Does**:
- Use official Reddit website
- Enable Electron security features
- Validate all URLs
- Isolate JavaScript contexts
- Disable dangerous APIs
- Respect Reddit's authentication

❌ **Doesn't**:
- Expose Node.js to Reddit
- Allow arbitrary code execution
- Transmit your data anywhere
- Require unreasonable permissions
- Modify Reddit's behavior

**For details**: See [SECURITY.md](SECURITY.md)

---

## 📈 Next Steps

### Short Term (Today)
1. ✅ Install dependencies
2. ✅ Test in development mode
3. ✅ Build packages
4. ✅ Test packages

### Medium Term (This Week)
1. Test on multiple Linux distributions
2. Test various Reddit features
3. Test keyboard shortcuts
4. Verify package installation/uninstallation

### Long Term (Future)
1. Share with friends/users
2. Distribute packages online
3. Gather feedback
4. Implement improvements
5. Add new features

---

## 🤝 Contributing

Want to improve Reddit Desktop?

1. **Read**: [CONTRIBUTING.md](CONTRIBUTING.md)
2. **Fork**: GitHub repository
3. **Code**: Make your improvements
4. **Test**: Verify your changes work
5. **Submit**: Create a pull request

**Good contributions**:
- Bug fixes
- Documentation improvements
- Performance enhancements
- Security audits
- User experience improvements

---

## 📖 Learn More

| Topic | Document |
|-------|----------|
| Complete guide | [README.md](README.md) |
| Development | [DEVELOPMENT.md](DEVELOPMENT.md) |
| Security model | [SECURITY.md](SECURITY.md) |
| All files | [FILE_MANIFEST.md](FILE_MANIFEST.md) |
| Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Implementation status | [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) |

---

## 💬 FAQ

**Q: Is this the official Reddit app?**
A: No. This is an unofficial third-party wrapper. See [LICENSE](LICENSE) and [README.md](README.md#legal-disclaimers).

**Q: Will my login be saved?**
A: Yes. Cookies are persisted automatically. You'll stay logged in.

**Q: Is my data secure?**
A: Yes. This application uses only official Reddit APIs and stores data locally. See [SECURITY.md](SECURITY.md).

**Q: Can I use this on Windows/Mac?**
A: Current build targets Linux (Ubuntu/Kali). Windows/Mac support would require additional work.

**Q: How do I uninstall?**
A: `sudo apt remove reddit-desktop` (if installed via .deb)
   Or just delete the AppImage file.

**Q: Can I contribute?**
A: Yes! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Q: Where's the source code?**
A: You're looking at it! In the `src/` directory.

**Q: What license is this?**
A: MIT License. See [LICENSE](LICENSE).

---

## 🎉 You're All Set!

Everything you need is ready. Now:

1. **Run the setup** (if you haven't):
   ```bash
   cd /home/simarsinghrayat/LINUX-DESKTOP-APPS/csc-main/Reddit
   npm install && bash scripts/setup.sh
   ```

2. **Start developing**:
   ```bash
   npm run dev
   ```

3. **Build packages** (when ready):
   ```bash
   npm run package
   ```

4. **Enjoy Reddit** on your Linux desktop!

---

**Happy coding! 🚀**

For questions or issues, refer to:
- [QUICKSTART.md](QUICKSTART.md) for quick answers
- [README.md](README.md) for complete documentation
- [DEVELOPMENT.md](DEVELOPMENT.md) if you're contributing

**Project Location**: `/home/simarsinghrayat/LINUX-DESKTOP-APPS/csc-main/Reddit/`
**License**: MIT
**Status**: ✅ Production Ready
