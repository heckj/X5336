import Lindenmayer
import XCTest

final class GraphicsContextRendererTests: XCTestCase {

    func testLSystem_boundingRectCalc() throws {
        let tree = Lindenmayer.Examples.kochCurve
        let evo1 = try tree.evolve(iterations: 3)
        let path: CGRect = GraphicsContextRenderer().calcBoundingRect(system: evo1)
        //print(path)
        //print("Size: \(path.size) -> height: \(path.size.height), width: \(path.size.width)")
        XCTAssertTrue(path.size.width >= 130)
        XCTAssertTrue(path.size.height >= 270)
    }

}
