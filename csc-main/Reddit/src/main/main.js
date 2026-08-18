'use strict';

const { app, BrowserWindow, Menu, session, shell, ipcMain } = require('electron');
const fs = require('node:fs');
const path = require('node:path');

const APP_URL = 'https://www.reddit.com/';
const PARTITION = 'persist:reddit';
const REDDIT_HOSTS = new Set(['reddit.com', 'www.reddit.com', 'old.reddit.com', 'new.reddit.com']);
const ALLOWED_EXTERNAL_PROTOCOLS = new Set(['http:', 'https:', 'mailto:', 'tel:']);
const ALLOWED_PERMISSIONS = new Set(['media', 'notifications', 'clipboard-read', 'clipboard-sanitized-write', 'camera', 'microphone']);

let mainWindow;
let statePath;

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
    return url.protocol === 'https:' && hostMatches(url.hostname.toLowerCase(), REDDIT_HOSTS);
  } catch {
    return false;
  }
}

/**
 * Safely open external URLs using the system default browser
 */
function openExternal(value) {
  try {
    const url = new URL(value);
    if (ALLOWED_EXTERNAL_PROTOCOLS.has(url.protocol)) {
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
    if ([state.width, state.height].every(Number.isInteger)) {
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

/**
 * Configure session permissions and download handling
 */
function configureSession(appSession) {
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

/**
 * Apply navigation policies to a browser window
 */
function applyNavigationPolicy(window) {
  const contents = window.webContents;

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
          preload: path.join(__dirname, '../preload/preload.js'),
          contextIsolation: true,
          nodeIntegration: false,
          sandbox: true,
          webSecurity: true,
          partition: PARTITION,
        },
      },
    };
  });

  contents.on('did-create-window', applyNavigationPolicy);

  for (const eventName of ['will-navigate', 'will-redirect']) {
    contents.on(eventName, (event, url) => {
      if (!isTrustedRedditUrl(url)) {
        event.preventDefault();
        openExternal(url);
      }
    });
  }

  // Handle load failures
  contents.on('did-fail-load', (_event, errorCode, _errorDescription, validatedURL, isMainFrame) => {
    if (isMainFrame && errorCode !== -3) {
      void window.loadFile(path.join(__dirname, '../assets/offline.html'));
    }
  });

  // Handle renderer process crashes
  contents.on('render-process-gone', () => {
    if (!window.isDestroyed()) {
      void window.loadURL(APP_URL);
    }
  });
}

/**
 * Create the application menu
 */
function createMenu() {
  Menu.setApplicationMenu(
    Menu.buildFromTemplate([
      {
        label: 'File',
        submenu: [
          { label: 'New Reddit Window', accelerator: 'CmdOrCtrl+N', click: () => createWindow() },
          { label: 'Open Reddit', accelerator: 'CmdOrCtrl+O', click: () => mainWindow?.loadURL(APP_URL) },
          { role: 'close', accelerator: 'CmdOrCtrl+W' },
          { type: 'separator' },
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
          { type: 'separator' },
          { role: 'zoomIn', accelerator: 'CmdOrCtrl+Plus' },
          { role: 'zoomOut', accelerator: 'CmdOrCtrl+Minus' },
          { role: 'resetZoom', accelerator: 'CmdOrCtrl+0' },
          { type: 'separator' },
          { role: 'togglefullscreen', accelerator: 'F11' },
          ...(app.isPackaged ? [] : [{ role: 'toggleDevTools', accelerator: 'CmdOrCtrl+Shift+I' }]),
        ],
      },
      {
        label: 'Navigate',
        submenu: [
          { role: 'back', accelerator: 'Alt+Left' },
          { role: 'forward', accelerator: 'Alt+Right' },
          { type: 'separator' },
          { label: 'Home', accelerator: 'Alt+Home', click: () => mainWindow?.loadURL(APP_URL) },
        ],
      },
      {
        label: 'Help',
        submenu: [
          {
            label: 'Reddit Website',
            click: () => openExternal('https://www.reddit.com'),
          },
          {
            label: 'Reddit Help',
            click: () => openExternal('https://www.reddit.com/r/help/'),
          },
          { type: 'separator' },
          { role: 'about' },
        ],
      },
    ])
  );
}

/**
 * Create the main application window
 */
async function createWindow() {
  if (!statePath) {
    statePath = path.join(app.getPath('userData'), 'window-state.json');
  }

  const mainWindow = new BrowserWindow({
    ...readWindowState(),
    minWidth: 900,
    minHeight: 600,
    title: 'Reddit',
    icon: path.join(__dirname, '../assets/icons/512.png'),
    webPreferences: {
      preload: path.join(__dirname, '../preload/preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      webSecurity: true,
      partition: PARTITION,
    },
  });

  applyNavigationPolicy(mainWindow);

  mainWindow.on('resize', saveWindowState);
  mainWindow.on('move', saveWindowState);
  mainWindow.on('closed', () => {
    if (global.mainWindow === mainWindow) {
      global.mainWindow = null;
    }
  });

  await mainWindow.loadURL(APP_URL);

  if (global.mainWindow === undefined) {
    global.mainWindow = mainWindow;
  }

  return mainWindow;
}

// IPC handlers
ipcMain.handle('retry-load', () => {
  if (mainWindow && !mainWindow.isDestroyed()) {
    return mainWindow.loadURL(APP_URL);
  }
});

// Application lifecycle
if (!app.requestSingleInstanceLock()) {
  app.quit();
} else {
  app.whenReady().then(async () => {
    configureSession(session.fromPartition(PARTITION));
    createMenu();
    mainWindow = await createWindow();

    app.on('activate', () => {
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
