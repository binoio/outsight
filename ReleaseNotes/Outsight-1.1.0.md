## Outsight 1.1.0

### Automatic updates
- Outsight now updates itself via Sparkle. Check manually with **Outsight ▸ Check for Updates…**, or manage automatic checks and downloads in **Settings ▸ Updates**.

### Under the hood
- Replaced the ship-it submodule with self-contained build, test, run, and release scripts (`Scripts/`).
- App notarization now uses Apple's App Store Connect API (`notarytool`) with EdDSA-signed Sparkle update appcasts.
