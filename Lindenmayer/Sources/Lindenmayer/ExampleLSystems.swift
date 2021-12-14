//
//  ExampleLSystems.swift
//  
//
//  Created by Joseph Heck on 12/14/21.
//

import Foundation

public enum Examples {
    
}


public extension Examples {
        
    // - MARK: Algae example
    
    struct A: Module {
        public var name = "A"
    }
    static var a = A()
    struct B: Module {
        public var name = "B"
    }
    static var b = B()

    static var algae = LSystem(a, rules: [
        ConcreteRule(a, { _, _, _ in
            [a,b]
        }),
        ConcreteRule(b, { _, _, _ in
            [a]
        })
    ])
    
    // - MARK: Fractal tree example
    
    struct Leaf: Module {
        public var name = "L"
        public var render2D: RenderCommand = .draw(5.0) // would be neat to make this green...
    }
    static var leaf = Leaf()
    
    struct Stem: Module {
        public var name = "I"
        public var render2D: RenderCommand = .draw(10.0) // would be neat to make this green...
    }
    static var stem = Stem()

    static var fractalTree = LSystem(leaf, rules: [
        ConcreteRule(leaf, { _, _, _ in
            [stem, Modules.branch, Modules.TurnLeft(45), leaf, Modules.endbranch, Modules.TurnRight(45), leaf]
        }),
        ConcreteRule(stem, { _, _, _ in
            [stem, stem]
        })
    ])

}
