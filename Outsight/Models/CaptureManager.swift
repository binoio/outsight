import Foundation
import ScreenCaptureKit
import CoreGraphics
import Combine
import AVFoundation

class CaptureManager: NSObject, SCStreamOutput, ObservableObject {
    @Published var currentFrame: CVPixelBuffer?
    private var stream: SCStream?
    private let videoOutputQueue = DispatchQueue(label: "com.ralph.Outsight.VideoOutputQueue")
    
    func startCapture(display: SCDisplay) async {
        stopCapture()
        
        let contentFilter = SCContentFilter(display: display, excludingWindows: [])
        let config = SCStreamConfiguration()
        config.width = Int(display.width) * 2 // HiDPI
        config.height = Int(display.height) * 2
        config.minimumFrameInterval = CMTime(value: 1, timescale: 60)
        config.queueDepth = 5
        
        // Audio not required
        config.capturesAudio = false
        
        do {
            stream = SCStream(filter: contentFilter, configuration: config, delegate: nil)
            try stream?.addStreamOutput(self, type: .screen, sampleHandlerQueue: videoOutputQueue)
            try await stream?.startCapture()
        } catch {
            print("Failed to start capture: \(error)")
        }
    }
    
    func stopCapture() {
        stream?.stopCapture()
        stream = nil
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen else { return }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            self.currentFrame = pixelBuffer
        }
    }
}
