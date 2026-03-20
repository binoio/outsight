import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var permissionsManager: PermissionsManager
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            PermissionsSettingsView()
                .tabItem {
                    Label("Permissions", systemImage: "lock.shield")
                }
        }
        .frame(width: 450, height: 450)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("showNoneOption") private var showNoneOption = true
    @AppStorage("showBuiltInDisplay") private var showBuiltInDisplay = true
    @AppStorage("showResolutionWatermark") private var showResolutionWatermark = false
    @StateObject private var loginManager = AppLoginManager.shared
    
    var body: some View {
        Form {
            Section {
                Toggle("Show 'None' option in Displays list", isOn: $showNoneOption)
                Toggle("Show Built-in Display in Displays list", isOn: $showBuiltInDisplay)
            } header: {
                Text("Sidebar")
            }
            
            Section {
                Toggle("Show Resolution watermark", isOn: $showResolutionWatermark)
            } header: {
                Text("Capture")
            }
            
            Section {
                Toggle("Open at Login", isOn: $loginManager.isEnabled)
            } header: {
                Text("System")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct PermissionsSettingsView: View {
    @EnvironmentObject var permissionsManager: PermissionsManager
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Screen Recording") {
                    StatusIndicator(isAuthorized: permissionsManager.isScreenRecordingAuthorized)
                }
            } header: {
                Text("Authorization Status")
            } footer: {
                Text("Outsight requires screen recording permission to capture and display live content from your displays.")
            }
            
            Section {
                Button("Open System Settings") {
                    permissionsManager.openSystemSettings()
                }
                
                Button("Reset Permissions", role: .destructive) {
                    permissionsManager.resetPermissions()
                }
            } header: {
                Text("Troubleshooting")
            }
        }
        .formStyle(.grouped)
    }
}

struct StatusIndicator: View {
    let isAuthorized: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isAuthorized ? .green : .red)
            Text(isAuthorized ? "Authorized" : "Denied")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
