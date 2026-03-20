import XCTest
import AppKit

final class AppIconTests: XCTestCase {
    func testAppIconIsCustom() {
        guard let icon = NSApp.applicationIconImage else {
            XCTFail("App icon should not be nil")
            return
        }
        
        XCTAssertFalse(icon.representations.isEmpty, "App icon should have representations")
        XCTAssertGreaterThan(icon.size.width, 0, "Icon width should be greater than 0")
        XCTAssertGreaterThan(icon.size.height, 0, "Icon height should be greater than 0")
    }
}
