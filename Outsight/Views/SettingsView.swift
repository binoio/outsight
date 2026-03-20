import SwiftUI

struct SettingsView: View {
    @StateObject private var permissionsManager = PermissionsManager()
    
    var body: some View {
        Form {
            Section("Permissions") {
                HStack {
                    Text("Screen Recording Permission")
                    Spacer()
                    Image(systemName: permissionsManager.isScreenRecordingAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(permissionsManager.isScreenRecordingAuthorized ? .green : .red)
                }
                
                HStack {
                    Text("Audio Recording Permission")
                    Spacer()
                    Image(systemName: permissionsManager.isAudioRecordingAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(permissionsManager.isAudioRecordingAuthorized ? .green : .red)
                }
                
                Button("Request Permissions") {
                    permissionsManager.requestScreenRecordingPermission()
                    Task {
                        await permissionsManager.requestAudioRecordingPermission()
                    }
                }
                
                Button("Open System Settings") {
                    permissionsManager.openSystemSettings()
                }
                
                Button("Reset Permissions", role: .destructive) {
                    permissionsManager.resetPermissions()
                }
            }
        }
        .padding()
        .frame(width: 400, height: 250)
        .onAppear {
            permissionsManager.checkPermissions()
        }
    }
}
