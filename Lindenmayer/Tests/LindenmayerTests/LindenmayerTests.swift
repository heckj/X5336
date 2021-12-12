// @testable
import Lindenmayer
import XCTest

final class LindenmayerTests: XCTestCase {

    func testBuiltins() {
        XCTAssertNotNil(Lindenmayer.Modules.internode)
    }
    
    func testModuleFoo() {
        struct Foo: Module {
            var name: String = "foo"
            var params: [String : Double] = [:]
        }
        let x = Foo()
        // Verify name is passed out as 'description'
        XCTAssertEqual(x.description, "foo")
        XCTAssertEqual(x.params.count, 0)
        // Verify default built-in behavior for a new module
        XCTAssertEqual(x.render2D, RenderCommand.ignore)
        XCTAssertEqual(x.render3D, RenderCommand.ignore)
        // Verify subscript lookup returns nil, but doesn't throw
        XCTAssertNil(x[dynamicMember: "something"])
        XCTAssertNil(x.something)
    }
}
