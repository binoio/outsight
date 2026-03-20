import SwiftUI

@main
struct OutsightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            SidebarCommands()
        }
        Settings {
            SettingsView()
        }
    }
}
