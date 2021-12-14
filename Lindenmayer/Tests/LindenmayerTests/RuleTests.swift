import Lindenmayer
import XCTest

final class RuleTests: XCTestCase {

    struct Foo: Module {
        var name: String = "foo"
    }
    let foo = Foo()

    func testRuleDefaults() throws {
        
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            XCTAssertNotNil(ctx)
            XCTAssertNil(lctx)
            XCTAssertNil(rctx)
            
            return ctx
        }
        XCTAssertNotNil(r)
        let check = r.evaluate(nil, foo, nil)
        XCTAssertEqual(check, false)
    }
    
    func testRuleBasicMatch() throws {
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            return self.foo
        }
        
        XCTAssertEqual(r.evaluate(nil, Modules.internode, nil), true)
    }

    func testRuleBasicFailMatch() throws {
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            return self.foo
        }
        
        XCTAssertEqual(r.evaluate(nil, foo, nil), false)
    }

    func testRuleMatchExtraRight() throws {
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            return self.foo
        }
        
        XCTAssertEqual(r.evaluate(nil, Modules.internode, foo), true)
    }

    func testRuleMatchExtraLeft() throws {
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            return self.foo
        }
        
        XCTAssertEqual(r.evaluate(foo, Modules.internode, nil), true)
    }

    func testRuleMatchExtraLeftAndRight() throws {
        let r = ConcreteRule(Modules.internode) { (lctx, ctx, rctx) -> Module in
            return self.foo
        }
        
        XCTAssertEqual(r.evaluate(foo, Modules.internode, foo), true)
    }

}
