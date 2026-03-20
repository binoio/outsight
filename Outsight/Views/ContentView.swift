import SwiftUI

struct ContentView: View {
    @State private var selection: String? = "None"
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            MainView(selection: $selection)
        }
        .navigationTitle("Outsight")
    }
}

struct SidebarView: View {
    @Binding var selection: String?
    
    var body: some View {
        List(selection: $selection) {
            Section("Displays") {
                Text("None").tag("None")
                // Displays will be added here
            }
        }
        .listStyle(.sidebar)
    }
}

struct MainView: View {
    @Binding var selection: String?
    
    var body: some View {
        VStack {
            if selection == "None" {
                Text("Select a display to start capturing")
                    .foregroundColor(.secondary)
            } else {
                Text("Capturing display: \(selection ?? "Unknown")")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
