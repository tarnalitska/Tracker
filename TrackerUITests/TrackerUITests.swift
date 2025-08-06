import XCTest

final class TrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {

    }

    @MainActor
    func testExample() throws {

        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
