//
//  ExampleLSystems.swift
//  
//
//  Created by Joseph Heck on 12/14/21.
//

import Foundation

public enum Examples {}

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
        ConcreteRule(A.self, { _, _, _ in
            [a,b]
        }),
        ConcreteRule(B.self, { _, _, _ in
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
        ConcreteRule(Leaf.self, { _, _, _ in
            [stem, Modules.branch, Modules.TurnLeft(45), leaf, Modules.endbranch, Modules.TurnRight(45), leaf]
        }),
        ConcreteRule(Stem.self, { _, _, _ in
            [stem, stem]
        })
    ])

    // - MARK: Koch curve example
    
    static var kochCurve = LSystem(Modules.Draw(10), rules: [
        ConcreteRule(Modules.Draw.self, { _, _, _ in
            [Modules.Draw(10), Modules.TurnLeft(), Modules.Draw(10), Modules.TurnRight(), Modules.Draw(10), Modules.TurnRight(), Modules.Draw(10), Modules.TurnLeft(), Modules.Draw(10)]
        })
    ])

    // - MARK: Sierpinski triangle example
    
    // to enable this, I need to support an axiom of more than a single module, and a decomposition step
    // so that each rule could produce a sequence of draw commands, not just a single one.
    
    /*
     
     variables : F G
     constants : + −
     start  : F−G−G
     rules  : (F → F−G+F+G−F), (G → GG)
     angle  : 120°
     Here, F means "draw forward", G means "draw forward", + means "turn left by angle", and − means "turn right by angle".
     
     Sierpinski Arrowhead Curve:
     
     variables : A B
     constants : + −
     start  : A
     rules  : (A → B−A−B), (B → A+B+A)
     angle  : 60°
     Here, A and B both mean "draw forward", + means "turn left by angle", and − means "turn right by angle" (see turtle graphics).
     */
    static var sierpinskiTriangle = LSystem(Modules.Draw(10), rules: [
        ConcreteRule(Modules.Draw.self, { _, _, _ in
            [Modules.Draw(10), Modules.TurnLeft(), Modules.Draw(10), Modules.TurnRight(), Modules.Draw(10), Modules.TurnRight(), Modules.Draw(10), Modules.TurnLeft(), Modules.Draw(10)]
        })
    ])
    
    // - MARK: dragon curve example

    /*
     variables : F G
     constants : + −
     start  : F
     rules  : (F → F+G), (G → F-G)
     angle  : 90°
     Here, F and G both mean "draw forward", + means "turn left by angle", and − means "turn right by angle".
     */
}
