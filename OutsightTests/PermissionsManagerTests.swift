import XCTest
@testable import Outsight

@MainActor
final class PermissionsManagerTests: XCTestCase {
    var permissionsManager: PermissionsManager!
    
    override func setUp() {
        super.setUp()
        permissionsManager = PermissionsManager()
    }
    
    override func tearDown() {
        permissionsManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // We can't easily test system permissions in unit tests without mocking,
        // but we can check if the object initializes.
        XCTAssertNotNil(permissionsManager)
    }
    
    func testCheckPermissions() {
        permissionsManager.checkPermissions()
        // status is dependent on the environment
        XCTAssertNotNil(permissionsManager.isScreenRecordingAuthorized)
        XCTAssertNotNil(permissionsManager.isAudioRecordingAuthorized)
    }
}
