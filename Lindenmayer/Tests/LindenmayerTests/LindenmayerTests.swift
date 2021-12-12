// @testable
import Lindenmayer
import XCTest

final class LindenmayerTests: XCTestCase {
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(Lindenmayer().text, "Hello, World!")
//    }

    func testBuiltins() {
        let x = Lindenmayer.Modules.internode
        XCTAssertEqual(x.description, "I")
    }
}
