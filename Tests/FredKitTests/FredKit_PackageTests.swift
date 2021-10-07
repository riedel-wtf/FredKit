import XCTest
@testable import FredKit_Package

final class FredKit_PackageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TimeInterval.day, 60*60*24)
        XCTAssertEqual(TimeInterval.week, 60*60*24*7)
        XCTAssertEqual(TimeInterval.year, 60*60*24*365)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
