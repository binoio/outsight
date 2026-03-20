import Foundation
import ScreenCaptureKit
import AVFoundation
import CoreGraphics

@MainActor
class PermissionsManager: ObservableObject {
    @Published var isScreenRecordingAuthorized: Bool = false
    @Published var isAudioRecordingAuthorized: Bool = false
    
    init() {
        checkPermissions()
    }
    
    func checkPermissions() {
        isScreenRecordingAuthorized = CGPreflightScreenCaptureAccess()
        isAudioRecordingAuthorized = AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    func requestScreenRecordingPermission() {
        // This will trigger the system prompt if not already authorized
        CGRequestScreenCaptureAccess()
        // We need to poll or check again after some time because CGRequestScreenCaptureAccess is asynchronous and doesn't provide a callback
        checkPermissions()
    }
    
    func requestAudioRecordingPermission() async {
        let authorized = await AVCaptureDevice.requestAccess(for: .audio)
        isAudioRecordingAuthorized = authorized
    }
    
    func resetPermissions() {
        // tccutil reset All com.ralph.Outsight
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tccutil")
        process.arguments = ["reset", "ScreenCapture", "com.ralph.Outsight"]
        
        do {
            try process.run()
            process.waitUntilExit()
            
            // Also reset audio
            let audioProcess = Process()
            audioProcess.executableURL = URL(fileURLWithPath: "/usr/bin/tccutil")
            audioProcess.arguments = ["reset", "Microphone", "com.ralph.Outsight"]
            try audioProcess.run()
            audioProcess.waitUntilExit()
            
            checkPermissions()
        } catch {
            print("Failed to reset permissions: \(error)")
        }
    }
}
