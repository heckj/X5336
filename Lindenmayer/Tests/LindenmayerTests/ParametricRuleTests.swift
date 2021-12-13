import Lindenmayer
import XCTest

final class ParametricRuleTests: XCTestCase {

    struct ParameterizedExample: Module {
        var name: String = "P"
        var params: [String : Double] = [:]
        // Create an initizer that accepts any named parameters you require.
        init(_ i: Double = 10) {
            params["i"] = i
        }
    }
    let p = ParameterizedExample()

    func testRuleDefaults() throws {
        
        let r = Rule(p) { (lctx, ctx, rctx) -> Module in
            guard let value = ctx.i else {
                throw Lindenmayer.RuntimeError<ParameterizedExample>(ctx)
            }
            return ParameterizedExample(value + 1.0)
            
        }
        
        XCTAssertNotNil(r)
        
        // verify evaluation will trigger with a default P module
        XCTAssertEqual(r.evaluate(nil, p, nil), true)
        // And with a different parameter value
        XCTAssertEqual(r.evaluate(nil, ParameterizedExample(21), nil), true)
        
        let newModules: [Module] = try r.produce(nil, p, nil)
        XCTAssertEqual(newModules.count, 1)
        let param = newModules[0] as! ParameterizedExample
        XCTAssertEqual(param.params.count, 1)
        // verify that our rule was processed, returning the same module with
        // an increased value from 10.0 -> 11.0.
        XCTAssertEqual(param.params["i"], 11)
        
    }
    
}
