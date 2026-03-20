import XCTest
@testable import Outsight
import ScreenCaptureKit

@MainActor
final class SidebarViewModelTests: XCTestCase {
    var viewModel: SidebarViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SidebarViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.displays.count, 0)
        XCTAssertNil(viewModel.selectedDisplayID)
    }
    
    func testHandleSelectionWithNil() {
        viewModel.selectedDisplayID = nil
        // captureManager should be stopped
        XCTAssertNotNil(viewModel.captureManager)
    }
}
