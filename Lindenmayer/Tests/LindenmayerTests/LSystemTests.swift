import Lindenmayer
import XCTest

final class LSystemTests: XCTestCase {

    func testLSystemDefault() throws {
        let x = LSystem(Lindenmayer.Modules.internode)
        XCTAssertNotNil(x)
        
        let result = try x.evolve()
        XCTAssertEqual(result.count, 1)
        
        XCTAssertEqual(result[0].description, "I")
        XCTAssertEqual(result[0].render2D, .draw(10))
        XCTAssertEqual(result[0].render3D, .ignore)
        
        let downcast = result[0] as! Internode
        XCTAssertEqual(downcast.description, "I")
    }
}
