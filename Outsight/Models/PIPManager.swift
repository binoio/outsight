import SwiftUI
import AppKit

class PIPManager: ObservableObject {
    private var pipPanel: NSPanel?
    @Published var isShowing: Bool = false
    
    func togglePIP(captureManager: CaptureManager) {
        if isShowing {
            hide()
        } else {
            show(captureManager: captureManager)
        }
    }
    
    private func show(captureManager: CaptureManager) {
        if pipPanel == nil {
            let panel = NSPanel(
                contentRect: NSRect(x: 100, y: 100, width: 400, height: 225),
                styleMask: [.nonactivatingPanel, .resizable, .fullSizeContentView, .hudWindow],
                backing: .buffered,
                defer: false
            )
            
            panel.isFloatingPanel = true
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.titleVisibility = .hidden
            panel.titlebarAppearsTransparent = true
            panel.backgroundColor = .black
            panel.hasShadow = true
            panel.isMovableByWindowBackground = true
            
            let contentView = NSHostingView(rootView: PIPView(captureManager: captureManager))
            panel.contentView = contentView
            
            self.pipPanel = panel
        }
        
        pipPanel?.makeKeyAndOrderFront(nil)
        isShowing = true
    }
    
    private func hide() {
        pipPanel?.orderOut(nil)
        isShowing = false
    }
}

struct PIPView: View {
    @ObservedObject var captureManager: CaptureManager
    
    var body: some View {
        CaptureView(pixelBuffer: captureManager.currentFrame)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}
