import Foundation
import ScreenCaptureKit
import Combine
import CoreGraphics

@MainActor
class SidebarViewModel: ObservableObject {
    @Published var displays: [SCDisplay] = []
    @Published var selectedDisplayID: CGDirectDisplayID? {
        didSet {
            handleSelection()
        }
    }
    
    @Published var captureManager = CaptureManager()
    
    init() {
        refreshDisplays()
    }
    
    func refreshDisplays() {
        Task {
            do {
                let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
                self.displays = content.displays
                
                // Keep selected display if still available
                if let selectedID = selectedDisplayID, !displays.contains(where: { $0.displayID == selectedID }) {
                    selectedDisplayID = nil
                }
            } catch {
                print("Error refreshing displays: \(error)")
            }
        }
    }
    
    private func handleSelection() {
        if let selectedID = selectedDisplayID, let display = displays.first(where: { $0.displayID == selectedID }) {
            Task {
                await captureManager.startCapture(display: display)
            }
        } else {
            captureManager.stopCapture()
        }
    }
}
