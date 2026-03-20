import XCTest

final class OutsightUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testAppLaunchAndSidebar() {
        // Verify sidebar content exists
        XCTAssert(app.staticTexts["Displays"].exists)
        XCTAssert(app.staticTexts["None"].exists)
    }
}
