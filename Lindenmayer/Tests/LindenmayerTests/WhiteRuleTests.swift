@testable import Lindenmayer
import XCTest

final class WhiteboxRuleTests: XCTestCase {

    func testRuleDefaults() throws {
        let r = ConcreteRule(Modules.Internode.self) { (lctx, ctx, rctx) -> Module in
            return ctx
        }
        XCTAssertNotNil(r)

        // Verify matchset with basic rule
        XCTAssertNotNil(r.matchset)
        XCTAssertNil(r.matchset.0)
        // Kind of a wrong hack - Type isn't equatable, but I can get a string description of it...
        XCTAssertEqual(String(describing: r.matchset.1), "Internode")
        XCTAssertNil(r.matchset.2)
    }

    func testRuleProduction() throws {
        let r = ConcreteRule(Modules.Internode.self) { _,_,_ in 
            return Modules.internode
        }
        XCTAssertNotNil(r)

        // Verify produce returns an Internode
        let newModule = try r.produce(nil, Modules.internode, nil)
        XCTAssertEqual(newModule.count, 1)
        XCTAssertEqual(newModule[0].description, "I")
    }

    
}
