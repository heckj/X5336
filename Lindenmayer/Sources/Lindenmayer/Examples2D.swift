//
//  ExampleLSystems.swift
//
//  Created by Joseph Heck on 12/14/21.
//

import Foundation

public enum Examples2D: String, CaseIterable, Identifiable {
    case sierpinskiTriangle
    case kochCurve
    case dragonCurve
    case fractalTree
    case barnsleyFern
    public var id: String { self.rawValue }
    public var lsystem: LSystem {
        get {
            switch self {
                case .sierpinskiTriangle:
                    return DetailedExamples.sierpinskiTriangle
                case .kochCurve:
                    return DetailedExamples.kochCurve
                case .dragonCurve:
                    return DetailedExamples.dragonCurve
                case .fractalTree:
                    return DetailedExamples.fractalTree
                case .barnsleyFern:
                    return DetailedExamples.barnsleyFern
            }
        }
    }
    public func evolved(iterations: Int) -> LSystem {
        var evolved: LSystem = self.lsystem
        do {
            evolved = try evolved.evolve(iterations: iterations)
        } catch {}
        return evolved
    }
}

struct DetailedExamples {
        
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
        Rule(A.self, { _ in
            [a,b]
        }),
        Rule(B.self, { _ in
            [a]
        })
    ])
    
    // - MARK: Fractal tree example
    
    struct Leaf: Module {
        static let green = ColorRepresentation(r: 0.3, g: 0.56, b: 0.0)
        public var name = "L"
        public var render2D: [TwoDRenderCommand] = [
            .setLineWidth(3),
            .setLineColor(green),
            .draw(5)
        ]
    }
    static var leaf = Leaf()
    
    struct Stem: Module {
        public var name = "I"
        public var render2D: [TwoDRenderCommand] = [.draw(10)] // would be neat to make this green...
    }
    static var stem = Stem()

    static var fractalTree = LSystem(leaf, rules: [
        Rule(Leaf.self, { _ in
            [stem, Modules.branch, Modules.TurnLeft(45), leaf, Modules.endbranch, Modules.TurnRight(45), leaf]
        }),
        Rule(Stem.self, { _ in
            [stem, stem]
        })
    ])

    // - MARK: Koch curve example
    
    static var kochCurve = LSystem(Modules.Draw(10), rules: [
        Rule(Modules.Draw.self, { _ in
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
            Rule(F.self, { _ in
                [f,Modules.TurnRight(120),g,Modules.TurnLeft(120),f,Modules.TurnLeft(120),g,Modules.TurnRight(120),f]
            }),
            Rule(G.self, { _ in
                [g,g]
            })
        ]
    )
    
    // - MARK: dragon curve example

    static var dragonCurve = LSystem(f,
        rules: [
            Rule(F.self, { _ in
                [f,Modules.TurnLeft(90),g]
            }),
            Rule(G.self, { _ in
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
            Rule(X.self, { _ in
                [f,Modules.TurnLeft(25),Modules.branch,Modules.branch,x,Modules.endbranch,Modules.TurnRight(25),x,Modules.endbranch,Modules.TurnRight(25),f,Modules.branch,Modules.TurnRight(25),f,x,Modules.endbranch,Modules.TurnLeft(25),x]
            }),
            Rule(F.self, { _ in
                [f,f]
            })
        ]
    )

}
