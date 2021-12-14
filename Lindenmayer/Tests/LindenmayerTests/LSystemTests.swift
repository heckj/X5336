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
        XCTAssertEqual(algae.state.map { $0.description }.joined(), "A")

        let result = try algae.evolve()
        XCTAssertEqual(result.count, 2)

        XCTAssertEqual(result[0].description, "A")
        XCTAssertEqual(result[1].description, "B")

        let resultSequence = result.map { $0.description }.joined()
        XCTAssertEqual(resultSequence, "AB")
    }

    func testAlgaeLSystem_evolve2() throws {
        var resultSequence = ""
        var algae = Lindenmayer.Examples.algae
        try algae.evolve()
        resultSequence = algae.state.map { $0.description }.joined()
        XCTAssertEqual(resultSequence, "AB")
        try algae.evolve() // debugPrint: true
        resultSequence = algae.state.map { $0.description }.joined()
        XCTAssertEqual(resultSequence, "ABA")
    }

    func testAlgaeLSystem_evolve3() throws {
        var resultSequence = ""
        var algae = Lindenmayer.Examples.algae
        try algae.evolve()
        try algae.evolve()
        try algae.evolve()
        resultSequence = algae.state.map { $0.description }.joined()
        XCTAssertEqual(resultSequence, "ABAAB")
        try algae.evolve()
        resultSequence = algae.state.map { $0.description }.joined()
        XCTAssertEqual(resultSequence, "ABAABABA")
    }

    func testFractalTree_evolve2() throws {
        var algae = Lindenmayer.Examples.fractalTree
        try algae.evolve()
        XCTAssertEqual(algae.state.map { $0.description }.joined(), "I[-L]+L")
        try algae.evolve()
        XCTAssertEqual(algae.state.map { $0.description }.joined(), "II[-I[-L]+L]+I[-L]+L")
    }

    func testFractalTree_rendering2() throws {
        var tree = Lindenmayer.Examples.fractalTree
        try tree.evolve(iterations: 2)
        XCTAssertEqual(tree.state.map { $0.description }.joined(), "II[-I[-L]+L]+I[-L]+L")
        
        let path: CGPath = LSystemCGRenderer().path(modules: tree.state)
        print(path)
//        XCTAssertEqual(path.boundingBoxOfPath, CGRect(x: 0, y: 0, width: 2.70711, height: 1.70711))
    }

}
