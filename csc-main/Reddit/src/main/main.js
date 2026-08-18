'use strict';

const { app, BrowserWindow, Menu, session, shell, ipcMain } = require('electron');
const fs = require('node:fs');
const path = require('node:path');

// ============================================================================
// Configuration
// ============================================================================

const APP_URL = 'https://www.reddit.com/';
const PARTITION = 'persist:reddit';

// Reddit domains and auth providers
const REDDIT_HOSTS = new Set([
  'reddit.com',
  'www.reddit.com',
  'old.reddit.com',
  'new.reddit.com',
  'i.reddit.com',
  'preview.reddit.com',
  'm.reddit.com',
]);

const AUTH_HOSTS = new Set([
  'accounts.google.com',
  'login.microsoftonline.com',
  'appleid.apple.com',
  'auth.reddit.com',
]);

const ALLOWED_PERMISSIONS = new Set([
  'media',
  'notifications',
  'clipboard-read',
  'clipboard-sanitized-write',
  'camera',
  'microphone',
]);

let mainWindow;
let statePath;

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Check if a hostname matches a set of trusted hosts
 */
function hostMatches(host, hosts) {
  return [...hosts].some((entry) => host === entry || host.endsWith(`.${entry}`));
}

/**
 * Validate if URL is a trusted Reddit URL
 */
function isTrustedRedditUrl(value) {
  try {
    const url = new URL(value);
    return url.protocol === 'https:' && (
      hostMatches(url.hostname.toLowerCase(), REDDIT_HOSTS) ||
      hostMatches(url.hostname.toLowerCase(), AUTH_HOSTS)
    );
  } catch {
    return false;
  }
}

/**
 * Safely open external URLs using the system default browser
 */
function openExternal(value) {
  if (value.startsWith('mailto:') || value.startsWith('tel:')) {
    void shell.openExternal(value);
    return;
  }
  try {
    const url = new URL(value);
    if (url.protocol === 'http:' || url.protocol === 'https:') {
      void shell.openExternal(url.toString());
    }
  } catch {}
}

/**
 * Read saved window state from file
 */
function readWindowState() {
  try {
    const state = JSON.parse(fs.readFileSync(statePath, 'utf8'));
    if (Number.isInteger(state.width) && Number.isInteger(state.height)) {
      return state;
    }
  } catch {}
  return { width: 1400, height: 900 };
}

/**
 * Save window state to file
 */
function saveWindowState() {
  if (!mainWindow || mainWindow.isDestroyed()) return;
  fs.mkdirSync(path.dirname(statePath), { recursive: true });
  fs.writeFileSync(statePath, JSON.stringify(mainWindow.getNormalBounds()));
}

// ============================================================================
// Session Configuration
// ============================================================================

/**
 * Configure session permissions and download handling
 * THIS IS THE CRITICAL MISSING PIECE!
 */
function configureSession(appSession) {
  // Set user agent to hide Electron signature (helps with website detection)
  appSession.setUserAgent(app.userAgentFallback.replace(/\sElectron\/[^\s]+/, ''));

  // Handle permission requests
  appSession.setPermissionRequestHandler((webContents, permission, callback) => {
    let origin;
    try {
      origin = new URL(webContents.getURL());
    } catch {
      callback(false);
      return;
    }
    callback(
      origin.protocol === 'https:' &&
      isTrustedRedditUrl(origin.toString()) &&
      ALLOWED_PERMISSIONS.has(permission)
    );
  });

  // Check permissions for background processes
  appSession.setPermissionCheckHandler((webContents, permission, requestingOrigin) => {
    return (
      ALLOWED_PERMISSIONS.has(permission) &&
      isTrustedRedditUrl(requestingOrigin || webContents.getURL())
    );
  });

  // Handle downloads
  appSession.on('will-download', (_event, item) => {
    item.setSavePath(path.join(app.getPath('downloads'), item.getFilename()));
  });
}

// ============================================================================
// Window Navigation Policies
// ============================================================================

/**
 * Apply navigation policies to a browser window
 */
function applyNavigationPolicy(window) {
  const contents = window.webContents;

  // Handle window.open() calls
  contents.setWindowOpenHandler(({ url }) => {
    if (!isTrustedRedditUrl(url)) {
      openExternal(url);
      return { action: 'deny' };
    }
    return {
      action: 'allow',
      overrideBrowserWindowOptions: {
        width: 1200,
        height: 800,
        title: 'Reddit',
        webPreferences: {
          preload: path.join(__dirname, 'preload.js'),
          contextIsolation: true,
          nodeIntegration: false,
          sandbox: true,
          webSecurity: true,
          partition: PARTITION,
        },
      },
    };
  });

  // Apply same policy to newly created windows
  contents.on('did-create-window', applyNavigationPolicy);

  // Handle navigation events
  for (const eventName of ['will-navigate', 'will-redirect']) {
    contents.on(eventName, (event, url) => {
      if (!isTrustedRedditUrl(url)) {
        event.preventDefault();
        openExternal(url);
      }
    });
  }

  // Handle network/load failures
  contents.on('did-fail-load', (_event, errorCode, _errorDescription, validatedURL, isMainFrame) => {
    if (isMainFrame && errorCode !== -3) {
      void window.loadFile(path.join(__dirname, 'offline.html'));
    }
  });

  // Handle renderer process crashes
  contents.on('render-process-gone', () => {
    if (!window.isDestroyed()) {
      void window.loadURL(APP_URL);
    }
  });

  // Track redirects for debugging
  contents.on('did-redirect-navigation', () => {
    if (mainWindow && !mainWindow.isDestroyed()) {
      mainWindow.focus();
    }
  });

  contents.on('did-navigate', () => {
    if (mainWindow && !mainWindow.isDestroyed()) {
      mainWindow.focus();
    }
  });
}

// ============================================================================
// Application Menu
// ============================================================================

/**
 * Create the application menu
 */
function createMenu() {
  Menu.setApplicationMenu(
    Menu.buildFromTemplate([
      {
        label: 'File',
        submenu: [
          {
            label: 'New Window',
            accelerator: 'CmdOrCtrl+N',
            click: () => createWindow(),
          },
          {
            label: 'Reload',
            accelerator: 'CmdOrCtrl+R',
            click: () => mainWindow?.webContents.reload(),
          },
          { role: 'back', accelerator: 'Alt+Left' },
          { role: 'forward', accelerator: 'Alt+Right' },
          { type: 'separator' },
          { role: 'close', accelerator: 'CmdOrCtrl+W' },
          { role: 'quit', accelerator: 'CmdOrCtrl+Q' },
        ],
      },
      {
        label: 'Edit',
        submenu: [
          { role: 'undo' },
          { role: 'redo' },
          { type: 'separator' },
          { role: 'cut' },
          { role: 'copy' },
          { role: 'paste' },
          { role: 'selectAll' },
        ],
      },
      {
        label: 'View',
        submenu: [
          { role: 'reload', accelerator: 'CmdOrCtrl+R' },
          { role: 'forceReload', accelerator: 'CmdOrCtrl+Shift+R' },
          { role: 'toggleDevTools', accelerator: 'CmdOrCtrl+Shift+I' },
          { type: 'separator' },
          { role: 'resetZoom', accelerator: 'CmdOrCtrl+0' },
          { role: 'zoomIn', accelerator: 'CmdOrCtrl+Plus' },
          { role: 'zoomOut', accelerator: 'CmdOrCtrl+Minus' },
          { type: 'separator' },
          { role: 'togglefullscreen', accelerator: 'F11' },
        ],
      },
      {
        label: 'Help',
        submenu: [
          {
            label: 'Visit Reddit Website',
            click: () => mainWindow?.loadURL(APP_URL),
          },
          {
            label: 'Reddit Help Center',
            click: () => openExternal('https://www.reddit.com/r/help/'),
          },
          { type: 'separator' },
          {
            label: 'About Reddit Desktop',
            click: () => {
              const aboutWindow = new BrowserWindow({
                width: 400,
                height: 300,
                modal: true,
                parent: mainWindow,
                show: false,
                webPreferences: {
                  nodeIntegration: false,
                  contextIsolation: true,
                },
              });
              aboutWindow.loadFile(path.join(__dirname, 'offline.html'));
              aboutWindow.show();
            },
          },
        ],
      },
    ])
  );
}

// ============================================================================
// Window Management
// ============================================================================

/**
 * Create the main application window
 */
async function createWindow() {
  statePath = path.join(app.getPath('userData'), 'window-state.json');

  mainWindow = new BrowserWindow({
    ...readWindowState(),
    minWidth: 900,
    minHeight: 600,
    title: 'Reddit',
    icon: path.join(__dirname, 'icons', '512.png'),
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      webSecurity: true,
      partition: PARTITION,
      enableRemoteModule: false,
    },
  });

  applyNavigationPolicy(mainWindow);

  mainWindow.on('resize', saveWindowState);
  mainWindow.on('move', saveWindowState);
  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  await mainWindow.loadURL(APP_URL);
  return mainWindow;
}

// ============================================================================
// IPC Handlers
// ============================================================================

ipcMain.handle('retry-load', () => {
  if (mainWindow && !mainWindow.isDestroyed()) {
    return mainWindow.loadURL(APP_URL);
  }
});

ipcMain.handle('get-app-version', () => app.getVersion());

ipcMain.handle('get-platform', () => process.platform);

// ============================================================================
// Application Lifecycle
// ============================================================================

// Prevent multiple instances
if (!app.requestSingleInstanceLock()) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });

  app.whenReady().then(async () => {
    // Configure session BEFORE creating window (THIS WAS THE CRITICAL BUG!)
    const appSession = session.fromPartition(PARTITION);
    configureSession(appSession);

    createMenu();
    await createWindow();

    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) {
        createWindow();
      }
    });
  });

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit();
    }
  });

  app.on('before-quit', () => {
    saveWindowState();
  });

  // Handle uncaught exceptions
  process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    if (mainWindow && !mainWindow.isDestroyed()) {
      mainWindow.webContents.send('error', error.message);
    }
  });
}
      if (!BrowserWindow.getAllWindows().length) {
        mainWindow = createWindow();
      }
    });
  });

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit();
    }
  });

  app.on('before-quit', saveWindowState);
}
