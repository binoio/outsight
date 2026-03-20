import Foundation
import ScreenCaptureKit
import Combine

@MainActor
class SidebarViewModel: ObservableObject {
    @Published var displays: [SCDisplay] = []
    @Published var selectedDisplayID: CGDirectDisplayID?
    
    init() {
        refreshDisplays()
    }
    
    func refreshDisplays() {
        Task {
            do {
                let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
                self.displays = content.displays
            } catch {
                print("Error refreshing displays: \(error)")
            }
        }
    }
}
