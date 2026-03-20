import SwiftUI

@main
struct OutsightApp: App {
    @StateObject private var permissionsManager = PermissionsManager()
    @StateObject private var sidebarViewModel = SidebarViewModel()
    @StateObject private var pipManager = PIPManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: sidebarViewModel)
                .environmentObject(permissionsManager)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            SidebarCommands()
            CommandGroup(after: .sidebar) {
                Button("Refresh Displays") {
                    sidebarViewModel.refreshDisplays()
                }
                .keyboardShortcut("r", modifiers: .command)
            }
            
            CommandGroup(after: .windowList) {
                Button("Picture-in-Picture") {
                    pipManager.togglePIP(captureManager: sidebarViewModel.captureManager)
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])
                .disabled(sidebarViewModel.selectedDisplayID == 0)
            }
        }
        Settings {
            SettingsView()
                .environmentObject(permissionsManager)
        }
    }
}
