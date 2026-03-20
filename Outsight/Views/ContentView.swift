import SwiftUI
import ScreenCaptureKit

struct ContentView: View {
    @ObservedObject var viewModel: SidebarViewModel
    @EnvironmentObject var permissionsManager: PermissionsManager
    
    var body: some View {
        if permissionsManager.hasInitialPermissions {
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
        } else {
            OnboardingView()
        }
    }
}

struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    @AppStorage("showNoneOption") private var showNoneOption = true
    @AppStorage("showBuiltInDisplay") private var showBuiltInDisplay = true
    
    var body: some View {
        List(selection: $viewModel.selectedDisplayID) {
            Section("Displays") {
                if showNoneOption {
                    HStack {
                        Image(systemName: "slash.circle")
                        Text("None")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .tag(0 as CGDirectDisplayID)
                }
                
                ForEach(viewModel.displays.filter { display in
                    if !showBuiltInDisplay && display.displayID == CGMainDisplayID() {
                        return false
                    }
                    return true
                }, id: \.displayID) { display in
                    HStack {
                        Image(systemName: "display")
                        Text(display.displayID == CGMainDisplayID() ? "Built-in Display" : "Display \(display.displayID)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .tag(display.displayID as CGDirectDisplayID)
                }
            }
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.refreshDisplays()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Refresh Displays")
            }
        }
    }
}

struct MainView: View {
    @ObservedObject var viewModel: SidebarViewModel
    @AppStorage("showResolutionWatermark") private var showResolutionWatermark = false
    
    var body: some View {
        VStack {
            if viewModel.selectedDisplayID != 0 {
                ZStack(alignment: .bottomTrailing) {
                    CaptureView(pixelBuffer: viewModel.captureManager.currentFrame)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if showResolutionWatermark, let frame = viewModel.captureManager.currentFrame {
                        Text("\(CVPixelBufferGetWidth(frame)) x \(CVPixelBufferGetHeight(frame))")
                            .font(.system(.caption, design: .monospaced))
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .padding(16)
                    }
                }
                .padding()
            } else {
                Text("Select a display to start capturing")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
