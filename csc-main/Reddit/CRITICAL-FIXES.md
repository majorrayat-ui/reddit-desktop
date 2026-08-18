# CRITICAL FIXES FOR REDDIT DESKTOP - UBUNTU LINUX ISSUES

## Root Cause Analysis

After deep analysis of working apps (Netflix, Jupyter, Teams) and comparing with Reddit Desktop, the following issues were identified:

### Issue 1: Package.json Entry Point Too Deep
**Problem**: `"main": "src/main/main.js"` requires correct relative path resolution
**Solution**: Ensure consistency with electron-builder configuration

### Issue 2: Icon Path Resolution
**Working Pattern (Teams, Netflix, Jupyter)**:
```javascript
icon: path.join(__dirname, '..', 'resources', 'filename.png')
```

**Reddit Current**: Uses `src/assets/icons/512.png` but path may not resolve correctly during runtime

### Issue 3: Module Loading Issue
**Problem**: The application claims "Installation Complete" but doesn't actually launch
**Root Cause**: AppImage may fail to load Electron modules or preload script

### Issue 4: Desktop Entry Execution Path
**Working Pattern**:
- Full absolute path without tilde: `/home/username/.local/bin/app-name`
- Uses `%U` for URL handling

### Issue 5: Missing User Agent Cleanup
**Working Pattern (Netflix, Jupyter)**:
```javascript
appSession.setUserAgent(app.userAgentFallback.replace(/\sElectron\/[^\s]+/, ''));
```
**Reddit Missing**: This prevents proper website loading

### Issue 6: IPC Handler Issues
**Problem**: IPC handlers defined but may cause module loading failures
**Solution**: Ensure IPC only exports safe methods

## Files to Fix

1. ✅ `src/main/main.js` - Complete rewrite with working pattern
2. ✅ `src/preload/preload.js` - Ensure correct exports
3. ✅ `package.json` - Correct configuration
4. ✅ `install.sh` - Better error handling and verification
5. ✅ `uninstall.sh` - Complete cleanup
6. ✅ `electron-builder.yml` - Correct icon path resolution

## Testing Strategy

1. Build AppImage locally
2. Verify AppImage can be executed
3. Test desktop entry creation
4. Verify app launches from menu
5. Test on fresh Ubuntu install if possible

## Implementation Changes

All changes will follow the proven working pattern from Teams/Netflix/Jupyter apps.
