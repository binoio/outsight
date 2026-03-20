import Foundation
import ScreenCaptureKit
import Combine
import CoreGraphics

@MainActor
class SidebarViewModel: ObservableObject {
    @Published var displays: [SCDisplay] = []
    @Published var selectedDisplayID: CGDirectDisplayID = 0 { // 0 represents None
        didSet {
            handleSelection()
        }
    }
    
    @Published var captureManager = CaptureManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Relay captureManager's changes to our subscribers
        captureManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func refreshDisplays() {
        // Don't call SCShareableContent if we don't have permission yet
        // to avoid triggering the system prompt prematurely.
        guard CGPreflightScreenCaptureAccess() else { return }
        
        Task {
            do {
                // Sometimes SCShareableContent needs a moment on app launch
                let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
                self.displays = content.displays
                
                // If we have a selection that's no longer available, reset to None
                if selectedDisplayID != 0 && !displays.contains(where: { $0.displayID == selectedDisplayID }) {
                    selectedDisplayID = 0
                }
            } catch {
                print("Error refreshing displays: \(error)")
            }
        }
    }
    
    private func handleSelection() {
        if selectedDisplayID != 0, let display = displays.first(where: { $0.displayID == selectedDisplayID }) {
            Task {
                await captureManager.startCapture(display: display)
            }
        } else {
            captureManager.stopCapture()
        }
    }
}
