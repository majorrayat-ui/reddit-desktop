# Security Model

Reddit Desktop takes security seriously. This document describes the security architecture and practices.

## Principles

1. **Principle of Least Privilege**: Each component has only the permissions it needs
2. **Defense in Depth**: Multiple layers of security controls
3. **Secure by Default**: Security features are enabled by default
4. **Transparency**: Security decisions are documented

## Electron Security Configuration

### Enabled Protections

✅ **Context Isolation** (`contextIsolation: true`)
- Renderer process runs in isolated JavaScript context
- Reddit website code cannot access Node.js APIs
- IPC communication is explicitly controlled

✅ **Sandbox** (`sandbox: true`)
- Renderer process runs in OS-level sandbox
- Filesystem access restricted
- Limits damage from potential exploits in Reddit or dependencies

✅ **Node.js Integration Disabled** (`nodeIntegration: false`)
- Reddit website has NO access to Node.js APIs
- Cannot use `require()`, `process`, `fs`, etc.
- Prevents privilege escalation attacks

✅ **Web Security** (`webSecurity: true`)
- Standard browser security features enabled
- CORS enforced
- Mixed content blocked

✅ **Validated Navigation**
- Navigation to non-Reddit sites is reviewed
- External links open in default browser
- Internal Reddit links remain in application

### Preload Bridge Security

The preload script (`src/preload/preload.js`) provides a minimal, carefully-designed bridge:

**Exposed APIs:**
- `window.redditDesktop.retry()` - Retry loading Reddit
- `window.redditDesktop.getAppVersion()` - Get version string
- `window.redditDesktop.getPlatform()` - Get platform name

**NOT Exposed:**
- ❌ `process` - Cannot access Node.js process
- ❌ `fs` - Cannot access file system
- ❌ `require` - Cannot load modules
- ❌ `ipcRenderer` - Cannot send/receive raw IPC (except through frozen object)
- ❌ `eval()` - Cannot execute arbitrary code
- ❌ Window APIs that could break out

### IPC Communication

All IPC channels are explicitly defined:

- `retry-load` - Retry loading Reddit (main → renderer)

Future additions MUST be:
1. Documented here
2. Reviewed for security implications
3. Validated and error-checked
4. Added to this security document

## Data Security

### What is Stored Locally

Reddit's session data (managed by Electron):

```
~/.config/Reddit/Partitions/persist:reddit/
```

Contains:
- Cookies
- Local storage (Reddit settings)
- IndexedDB (Reddit data)
- Service Worker cache

**Important**: This data is encrypted at rest (depends on Electron/OS configuration).

### What is NOT Sent Anywhere

- ❌ Reddit credentials (never visible to wrapper)
- ❌ Browsing history
- ❌ Posts/comments you create
- ❌ Messages
- ❌ Any personal data
- ❌ Analytics/telemetry (unless Reddit's website sends it)

### Network Security

- ✅ HTTPS required for all Reddit connections
- ✅ Certificate validation enforced
- ✅ Mixed content blocked
- ✅ HSTS (HTTP Strict Transport Security) honored

## Permissions Model

The application requests minimal permissions:

| Permission | Purpose | Rationale |
|-----------|---------|-----------|
| `media` | Microphone/camera for Reddit video | Reddit may use for streaming |
| `notifications` | Desktop notifications | Notify of Reddit events |
| `clipboard-read` | Clipboard access for sharing | Reddit may read on paste |
| `clipboard-write` | Clipboard access for sharing | Reddit uses for copy/share |

All permissions:
- ✅ Are explicitly granted to Reddit only
- ✅ Default to deny
- ✅ Cannot be granted to external content
- ✅ Require user approval (via browser mechanisms)

## Development Security

### In Development Mode Only

- DevTools accessible with <kbd>Ctrl+Shift+I</kbd>
- Console logging enabled
- Error details shown

### In Production Builds

- DevTools hidden
- Console logging disabled
- Minimal error details (user-friendly messages)

## Third-Party Dependencies

Reddit Desktop uses minimal dependencies:

**Runtime Dependencies:**
- None (Electron provides all needed APIs)

**Dev Dependencies:**
- `electron` - Secure version specified
- `electron-builder` - Official Electron packaging tool

All dependencies are:
- ✅ Pinned to specific versions
- ✅ Vetted for security
- ✅ From official npm registry
- ✅ Minimal (keep supply chain risk low)

## Reporting Security Issues

⚠️ **PLEASE DO NOT** create public GitHub issues for security vulnerabilities.

Instead:

1. Do NOT disclose details publicly
2. Email security concerns to maintainers
3. Include detailed reproduction steps
4. Allow reasonable time for patches before disclosure

## Audit Trail

**Code Review Checklist:**

Before each release:

- [ ] No `eval()` or `Function()` constructors
- [ ] No disabled security features
- [ ] No hardcoded credentials
- [ ] No unnecessary IPC channels
- [ ] Dependencies are up-to-date
- [ ] No secrets in configuration files
- [ ] Preload script is minimal
- [ ] All navigation is validated
- [ ] No sensitive data in logs

## Known Limitations

1. **Reddit's Security**: This wrapper relies on Reddit's security. If Reddit's website is compromised, this application may be affected.

2. **Electron Vulnerabilities**: Security depends on Electron being updated. Outdated Electron versions may have known vulnerabilities.

3. **Operating System**: Desktop environment and OS-level security affect this application's security.

## Security Through Transparency

This security model is:
- 📖 Documented (this file)
- 🔍 Reviewable (source code is readable)
- 🧪 Testable (anyone can review and test)
- 🔄 Improvable (issues can be addressed)

## Future Considerations

- Consider certificate pinning for reddit.com
- Implement automatic Electron updates
- Add periodic security dependency audits
- Consider security benchmarking

---

**Last Updated**: 2024-08-18
**Version**: 1.0.0
