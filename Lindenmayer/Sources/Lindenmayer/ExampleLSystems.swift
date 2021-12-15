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
        public var render2D: [TwoDRenderCommand] = [.draw(5.0)] // would be neat to make this green...
    }
    static var leaf = Leaf()
    
    struct Stem: Module {
        public var name = "I"
        public var render2D: [TwoDRenderCommand] = [.draw(10.0)] // would be neat to make this green...
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
    
    struct F: Module {
        public var name = "F"
        public var render2D: [TwoDRenderCommand] = [.draw(10.0)]
    }
    static var f = F()
    
    struct G: Module {
        public var name = "G"
        public var render2D: [TwoDRenderCommand] = [.draw(10.0)]
    }
    static var g = G()

    static var sierpinskiTriangle = LSystem(
        [f,Modules.TurnRight(120),g,Modules.TurnRight(120),g,Modules.TurnRight(120)],
        rules: [
            ConcreteRule(F.self, { _, _, _ in
                [f,Modules.TurnRight(120),g,Modules.TurnLeft(120),f,Modules.TurnLeft(120),g,Modules.TurnRight(120),f]
            }),
            ConcreteRule(G.self, { _, _, _ in
                [g,g]
            })
        ]
    )
    
    // - MARK: dragon curve example

    static var dragonCurve = LSystem(f,
        rules: [
            ConcreteRule(F.self, { _, _, _ in
                [f,Modules.TurnLeft(90),g]
            }),
            ConcreteRule(G.self, { _, _, _ in
                [f,Modules.TurnRight(90),g]
            })
        ]
    )

    // - MARK: Barnsley fern example
    struct X: Module {
        public var name = "X"
        public var render2D: [TwoDRenderCommand] = [.ignore]
    }
    static var x = X()
    
    static var barnsleyFern = LSystem(x,
        rules: [
            ConcreteRule(X.self, { _, _, _ in
                [f,Modules.TurnLeft(25),Modules.branch,Modules.branch,x,Modules.endbranch,Modules.TurnRight(25),x,Modules.endbranch,Modules.TurnRight(25),f,Modules.branch,Modules.TurnRight(25),f,x,Modules.endbranch,Modules.TurnLeft(25),x]
            }),
            ConcreteRule(F.self, { _, _, _ in
                [f,f]
            })
        ]
    )
    
    static var barnsleyFarmEvolved: LSystem {
        get {
            var sys = Lindenmayer.Examples.barnsleyFern //dragonCurve //sierpinskiTriangle //kochCurve
            do {
                sys = try sys.evolve(iterations: 6)
            } catch {}
            return sys
        }
    }


}
