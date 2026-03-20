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

    func testOnlyOneViewMenuExists() {
        let viewMenu = app.menuBars.menuBarItems["View"]
        XCTAssertTrue(viewMenu.exists, "The View menu should exist")
        
        // Count how many "View" menu bar items exist
        let count = app.menuBars.menuBarItems.matching(identifier: "View").count
        XCTAssertEqual(count, 1, "There should be exactly one View menu")
    }

    func testAppLaunchAndSidebar() {
        // If onboarding exists, click the grant button
        let grantButton = app.buttons["Grant Screen Recording Access"]
        if grantButton.exists {
            grantButton.click()
        }
        
        // Wait for elements to appear as they might take a second during initial load or after grant
        let noneText = app.staticTexts["None"]
        XCTAssertTrue(noneText.waitForExistence(timeout: 5), "None option should exist in the sidebar")
    }
}
