import SwiftUI
import Sparkle

@MainActor
class OutsightAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    // Started manually so XCTest runs (which host the app) never spin up
    // Sparkle's scheduled checks
    lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil)
    lazy var updaterViewModel = UpdaterViewModel(updater: updaterController.updater)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") != nil,
           NSClassFromString("XCTestCase") == nil {
            updaterController.startUpdater()
        }
    }
}

@main
struct OutsightApp: App {
    @NSApplicationDelegateAdaptor(OutsightAppDelegate.self) var appDelegate
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
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(viewModel: appDelegate.updaterViewModel)
            }
            
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
            SettingsView(updaterViewModel: appDelegate.updaterViewModel)
                .environmentObject(permissionsManager)
        }
    }
}
