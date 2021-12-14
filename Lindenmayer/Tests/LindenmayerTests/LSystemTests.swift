import Lindenmayer
import XCTest

final class LSystemTests: XCTestCase {

    func testLSystemDefault() throws {
        var x = LSystem(Lindenmayer.Modules.internode)
        XCTAssertNotNil(x)
        
        let result = x.state
        XCTAssertEqual(result.count, 1)
        
        XCTAssertEqual(result[0].description, "I")
        XCTAssertEqual(result[0].render2D, .draw(10))
        XCTAssertEqual(result[0].render3D, .ignore)
        
        try x.evolve()
        XCTAssertEqual(x.state.count, 1)
        let downcast = x.state[0] as! Lindenmayer.Modules.Internode
        XCTAssertEqual(downcast.description, "I")
    }

    func testAlgaeLSystem_evolve1() throws {
        var algae = Lindenmayer.Examples.algae
        XCTAssertNotNil(algae)
        XCTAssertEqual(algae.state.count, 1)
        
        let result = try algae.evolve()
        XCTAssertEqual(result.count, 2)
        
        XCTAssertEqual(result[0].description, "A")
        XCTAssertEqual(result[1].description, "B")
    }
}
