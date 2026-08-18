# Contributing to Reddit Desktop

Thank you for your interest in contributing to Reddit Desktop! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Assume good intentions
- Help others learn and grow

## Before You Start

1. Check [GitHub Issues](https://github.com/example/reddit-desktop/issues) for existing reports
2. Read the [Security Policy](SECURITY.md)
3. Understand the [Architecture](README.md#architecture)
4. Review the [License](LICENSE)

## Types of Contributions

### Bug Reports

**Before reporting:**
- Test with the latest version
- Check if the issue already exists
- Try troubleshooting steps in [README.md](README.md#troubleshooting)

**When reporting:**
```
Title: Brief description of the bug

Environment:
- OS: Ubuntu 24.04 / Kali Linux
- Version: v1.0.0
- Electron version: [from About dialog]

Steps to Reproduce:
1. Launch application
2. Navigate to subreddit
3. ...

Expected Behavior:
The page should load

Actual Behavior:
Error message appears

Screenshots/Logs:
[paste relevant error messages]
```

### Feature Requests

**Focus on:**
- Use cases and problems solved
- Implementation ideas (if any)
- Real-world scenarios

**Example:**
```
Feature: Full-screen reader mode for posts

Problem: Long text posts are hard to read at normal zoom

Suggestion: Add a reader mode that:
- Focuses on post content
- Increases text size
- Removes distractions
```

### Code Contributions

#### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/example/reddit-desktop.git
cd reddit-desktop

# Run setup script
bash scripts/setup.sh

# Or manual setup
npm install
bash scripts/generate-icons.sh  # Generate icons from SVG
```

#### Development Workflow

```bash
# Start development server with logging
npm run dev

# In another terminal, make changes and reload with Ctrl+Shift+R

# Validate your code before committing
npm run validate
```

#### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow existing code style
   - Add comments for complex logic
   - Keep commits atomic and well-documented

3. **Test thoroughly**
   ```bash
   npm run dev
   # Test all affected functionality
   ```

4. **Validate syntax**
   ```bash
   npm run validate
   ```

5. **Commit with clear messages**
   ```bash
   git commit -m "Add feature: Clear description"
   ```

6. **Push and create a Pull Request**

#### Code Style Guidelines

**JavaScript/Node.js:**
- Use `'use strict';` at file top
- Use consistent indentation (2 spaces)
- Use meaningful variable names
- Comment complex logic
- Use template literals for strings with variables

**Comments:**
```javascript
/**
 * Clear description of what this function does
 * @param {string} url - The URL to validate
 * @returns {boolean} True if URL is trusted
 */
function isTrustedRedditUrl(url) {
  // ...
}
```

**Example:**
```javascript
// Good
const ALLOWED_HOSTS = new Set(['reddit.com', 'www.reddit.com']);

function validateUrl(url) {
  try {
    const parsed = new URL(url);
    return ALLOWED_HOSTS.has(parsed.hostname);
  } catch {
    return false;
  }
}

// Avoid
function validateUrl(url){
try{
const x=new URL(url);
return x.hostname==='reddit.com'||x.hostname==='www.reddit.com';
}catch{return false;}}
```

## Testing

### Manual Testing Checklist

- [ ] Application launches without errors
- [ ] Reddit homepage loads
- [ ] Can navigate between subreddits
- [ ] Can scroll feed smoothly
- [ ] Back/Forward navigation works
- [ ] Reload functionality works
- [ ] Zoom in/out works
- [ ] External links open in browser
- [ ] Can login/logout
- [ ] Session persists after restart
- [ ] Multiple windows work
- [ ] Fullscreen works
- [ ] Application closes cleanly

### Reporting Test Results

Include in pull requests:
- OS and version tested
- Any errors encountered
- Screenshots if UI-related
- Performance observations

## Git Workflow

### Commit Messages

```
Type: Brief description (50 chars max)

Longer explanation (if needed):
- What changed
- Why it changed
- How to test it

Fixes #123  (reference issues)
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Formatting, missing semicolons, etc.
- `refactor:` - Code restructuring
- `perf:` - Performance improvements
- `test:` - Adding tests
- `chore:` - Build, dependencies, tools

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Code cleanup

## Pull Request Process

1. **Update documentation** - Reflect any changes
2. **Add tests** - If applicable
3. **Update CHANGELOG** - Note your contribution
4. **Create PR** with:
   - Clear title
   - Description of changes
   - Link to related issue
   - Testing notes
5. **Respond to feedback** - Address reviewer comments
6. **Get approval** - Wait for maintainer review

## Documentation Contributions

- Update README for user-facing changes
- Add inline code comments
- Create/update troubleshooting guides
- Improve error messages

## Areas to Contribute

### High Priority
- Performance improvements
- Security enhancements
- Linux desktop integration improvements
- Error handling improvements

### Medium Priority
- Better error messages
- Documentation improvements
- Additional keyboard shortcuts
- UI polish

### Nice to Have
- Animation improvements
- Additional theme options
- Extended Reddit feature support

## Questions?

- 📖 Read the [Architecture section](README.md#architecture)
- 🔍 Review existing [code examples](src/)
- 💬 Open a discussion issue
- 📧 Email maintainers

## Recognition

Contributors will be:
- Thanked in commit messages
- Listed in CHANGELOG
- Recognized in project documentation

---

**Thank you for contributing to Reddit Desktop! 🚀**
