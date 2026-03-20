import SwiftUI
import ScreenCaptureKit

struct ContentView: View {
    @StateObject private var viewModel = SidebarViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            MainView(viewModel: viewModel)
        }
        .navigationTitle("Outsight")
        .onAppear {
            viewModel.refreshDisplays()
        }
    }
}

struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedDisplayID) {
            Section("System") {
                Text("None").tag(nil as CGDirectDisplayID?)
            }
            
            Section("Displays") {
                ForEach(viewModel.displays, id: \.displayID) { display in
                    HStack {
                        Image(systemName: "display")
                        Text("Display \(display.displayID)")
                    }
                    .tag(display.displayID as CGDirectDisplayID?)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

struct MainView: View {
    @ObservedObject var viewModel: SidebarViewModel
    
    var body: some View {
        VStack {
            if viewModel.selectedDisplayID != nil {
                CaptureView(pixelBuffer: viewModel.captureManager.currentFrame)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
            } else {
                Text("Select a display to start capturing")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
