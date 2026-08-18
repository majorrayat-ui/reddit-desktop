'use strict';

const { contextBridge, ipcRenderer } = require('electron');

/**
 * Expose safe desktop application APIs to the Reddit webpage
 * Only safe, read-only functions are exposed through this bridge
 */
contextBridge.exposeInMainWorld('redditDesktop', Object.freeze({
  /**
   * Retry loading Reddit after a connection failure
   */
  retry: () => ipcRenderer.invoke('retry-load'),

  /**
   * Get the application version
   */
  getAppVersion: () => '1.0.0',

  /**
   * Get the current platform
   */
  getPlatform: () => process.platform,
}));
