# Outsight

Outsight is a macOS screen capture utility that lets you mirror secondary displays in a window on your primary display. Outsight features ultra-low latency, Picture-in-Picture, and multi-display support.

![macOS 15.0+](https://img.shields.io/badge/macOS-15.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)

## Features

- **Live Screen Capture**: Monitor any display with ultra-low latency and minimal CPU usage.
- **Picture-in-Picture**: Keep an eye on your screens in a floating window while you work.
- **Multi-Display**: Toggle between connected displays seamlessly from the sidebar.
- **Automatic Updates**: Built-in Sparkle auto-updates (configurable in Settings > Updates or via Outsight ▸ Check for Updates…).
- **Privacy-First**: Built using ScreenCaptureKit for native macOS integration.

## Requirements

- macOS 15.0 or later
- Screen Recording permissions (requested on first launch)
- Xcode 15+ (for building)

## Building & Development

```bash
# Build debug version
Scripts/build.sh

# Build release version (unsigned)
Scripts/build.sh --release

# Build and launch
Scripts/run.sh

# Run unit tests (add --ui for the UI test suite)
Scripts/test.sh
```

## Releasing (signing, notarization, Sparkle appcast)

```bash
Scripts/release.sh
```

Builds, codesigns, notarizes via App Store Connect API (`notarytool`), staples, publishes the GitHub release, and updates the Sparkle appcast. Requires an Apple Developer account; see [RELEASE.md](RELEASE.md).

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Refresh Displays | ⌘R |
| Picture-in-Picture | ⇧⌘P |
| Settings | ⌘, |
