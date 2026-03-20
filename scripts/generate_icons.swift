import Cocoa
import CoreGraphics
import Foundation

func generateIcon(size: Int, name: String, path: String) {
    let width = size
    let height = size
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapContext = CGContext(data: nil,
                                  width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    let graphicsContext = NSGraphicsContext(cgContext: bitmapContext, flipped: false)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphicsContext
    
    // Background Squircle (macOS style)
    let rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
    let cornerRadius = CGFloat(size) * 0.2237
    let pathObj = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    
    let gradient = NSGradient(starting: NSColor.orange,
                              ending: NSColor.red)!
    gradient.draw(in: pathObj, angle: -90)
    
    // Outer Display Frame
    let outerDisplayRect = rect.insetBy(dx: CGFloat(size) * 0.15, dy: CGFloat(size) * 0.2)
    let outerPath = NSBezierPath(roundedRect: outerDisplayRect, xRadius: CGFloat(size) * 0.05, yRadius: CGFloat(size) * 0.05)
    NSColor.white.withAlphaComponent(0.2).set()
    outerPath.fill()
    NSColor.white.setStroke()
    outerPath.lineWidth = CGFloat(size) * 0.02
    outerPath.stroke()
    
    // Inner Display Frame
    let innerDisplayRect = outerDisplayRect.insetBy(dx: outerDisplayRect.width * 0.2, dy: outerDisplayRect.height * 0.2)
    let innerPath = NSBezierPath(roundedRect: innerDisplayRect, xRadius: CGFloat(size) * 0.03, yRadius: CGFloat(size) * 0.03)
    NSColor.white.withAlphaComponent(0.4).set()
    innerPath.fill()
    NSColor.white.setStroke()
    innerPath.lineWidth = CGFloat(size) * 0.015
    innerPath.stroke()
    
    // Display Stand
    let standRect = CGRect(x: CGFloat(size) * 0.45, y: CGFloat(size) * 0.1, width: CGFloat(size) * 0.1, height: CGFloat(size) * 0.1)
    let standPath = NSBezierPath(rect: standRect)
    NSColor.white.set()
    standPath.fill()
    
    let baseRect = CGRect(x: CGFloat(size) * 0.35, y: CGFloat(size) * 0.08, width: CGFloat(size) * 0.3, height: CGFloat(size) * 0.02)
    let basePath = NSBezierPath(roundedRect: baseRect, xRadius: CGFloat(size) * 0.01, yRadius: CGFloat(size) * 0.01)
    basePath.fill()
    
    NSGraphicsContext.restoreGraphicsState()
    
    if let cgImage = bitmapContext.makeImage() {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        if let pngData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
            let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path).appendingPathComponent("\(name).png")
            do {
                try pngData.write(to: fileURL)
                print("Wrote: \(fileURL.path) (\(width)x\(height))")
            } catch {
                print("Failed to write \(name): \(error)")
            }
        }
    }
}

let iconRelativePath = "Outsight/Resources/Assets.xcassets/AppIcon.appiconset"
let sizes: [Int] = [16, 32, 64, 128, 256, 512, 1024]

for size in sizes {
    generateIcon(size: size, name: "icon_\(size)", path: iconRelativePath)
}
