import XCTest
@testable import FLite

final class FLiteTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FLite().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
