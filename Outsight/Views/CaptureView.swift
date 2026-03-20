import SwiftUI
import CoreVideo
import AppKit

struct CaptureView: NSViewRepresentable {
    var pixelBuffer: CVPixelBuffer?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.layer = CALayer()
        view.wantsLayer = true
        view.layer?.contentsGravity = .resizeAspect
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let buffer = pixelBuffer {
            nsView.layer?.contents = buffer
        } else {
            nsView.layer?.contents = nil
        }
    }
}
