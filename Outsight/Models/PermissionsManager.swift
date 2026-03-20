import Foundation
import ScreenCaptureKit
import AVFoundation
import CoreGraphics
@MainActor
class PermissionsManager: ObservableObject {
    @Published var isScreenRecordingAuthorized: Bool = false

    var hasInitialPermissions: Bool {
        isScreenRecordingAuthorized
    }

    private var timer: Timer?

    init() {
        checkPermissions()
        startPolling()
    }

    deinit {
        timer?.invalidate()
    }

    func checkPermissions() {
        isScreenRecordingAuthorized = CGPreflightScreenCaptureAccess()
    }

    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkPermissions()
            }
        }
    }

    func requestScreenRecordingPermission() {
        CGRequestScreenCaptureAccess()
        checkPermissions()
    }

    func resetPermissions() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tccutil")
        process.arguments = ["reset", "ScreenCapture", "com.ralph.Outsight"]

        do {
            try process.run()
            process.waitUntilExit()
            checkPermissions()
        } catch {
            print("Failed to reset permissions: \(error)")
        }
    }

    func openSystemSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        NSWorkspace.shared.open(url)
    }
}
