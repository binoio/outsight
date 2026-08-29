# Release Guide

Outsight is distributed as a signed, notarized app with Sparkle auto-updates: an EdDSA-signed appcast at `docs/appcast.xml` is served from GitHub Pages (`https://binoio.github.io/outsight/appcast.xml`) and the zips live on GitHub Releases.

## Prerequisites

- Xcode so that `xcodebuild` and `xcrun` are available.
- A "Developer ID Application" signing identity in the keychain (override with `OUTSIGHT_SIGN_IDENTITY`).
- Notary credentials stored in a keychain profile (override with `OUTSIGHT_NOTARY_PROFILE`; `outsight-notary`, `kona-notary`, `atmo-notary`, and `edith-notary` are tried automatically): `xcrun notarytool store-credentials outsight-notary --key AuthKey_XXXX.p8 --key-id XXXX --issuer <issuer-uuid>` (never put credentials in a repo file).
- Sparkle EdDSA key pair in the login Keychain (`generate_keys` from the Sparkle tools under `build/DerivedData/SourcePackages/artifacts`). The public half is committed as `SUPublicEDKey` in `Outsight/Resources/Info.plist`; the release preflight verifies they match.
- `gh auth login` with access to `binoio/outsight`.

## One-step release

1. Bump `MARKETING_VERSION` **and** `CURRENT_PROJECT_VERSION` (kept identical; Sparkle compares `CFBundleVersion`) in `Outsight.xcodeproj/project.pbxproj` and `Outsight/Resources/Info.plist`.
2. Write `ReleaseNotes/Outsight-X.Y.Z.md` (GitHub release body) and `ReleaseNotes/Outsight-X.Y.Z.html` (embedded in the Sparkle appcast).
3. Commit everything, then run from the repo root:

```bash
zsh Scripts/release.sh
```

The script performs the following:

1. Preflight: clean working tree, version newer than the latest tag, matching build number, release notes present, signing identity, notary profile, and `gh` auth available.
2. Builds the Release configuration unsigned (`CODE_SIGNING_ALLOWED=NO`) into `build/DerivedData` and copies the app to `dist/Outsight.app`.
3. Verifies the bundle: bundle id, version, `SUFeedURL`, `SUPublicEDKey` (against the login Keychain), `SUEnableInstallerLauncherService`, the embedded `Sparkle.framework`, and the Frameworks rpath.
4. Codesigns inside-out via `Scripts/codesign_app.sh` (Sparkle helpers first, then the app; never `--deep`), notarizes via the App Store Connect API, and staples.
5. Regenerates `docs/appcast.xml` with an EdDSA signature from the login Keychain, embedding the HTML release notes.
6. Tags `vX.Y.Z`, publishes the GitHub release with the zip, then commits and pushes the appcast (release first, so the download URL exists before the appcast goes live). The Pages workflow deploys `docs/`, which serves the feed.

## Post-release checks

```bash
codesign --verify --deep --strict dist/Outsight.app
spctl -a -vv -t exec dist/Outsight.app                  # "Notarized Developer ID" after stapling
```

On a machine with the previous version installed, "Check for Updates…" in the Outsight menu should offer the new release once Pages has deployed.
