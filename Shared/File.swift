//
//  File.swift
//  X5336
//
//  Created by Joseph Heck on 12/9/21.
//

import Foundation

public protocol Module : CustomStringConvertible {
    var name: String { get }
    var params: [String:Double] { get }
//    var params:[String] { get }
//    func getParam(_ :String) -> Double
    
    // and maybe something to evaluate the rule into a 2D or 3D representation
}

struct I: Module {
    
    var name = "I"
    var params: [String:Double] = [:]
//    var params: [String] = []
//    func getParam(_: String) -> Double {
//        0.0
//    }
    
    // - CustomStringConvertible
    
    var description: String {
        return name
    }

    // - Comparable
    
    static func < (lhs: I, rhs: I) -> Bool {
        lhs.name < rhs.name
    }
}

public struct Rule {
    var produce: (Module?,Module,Module?) -> [Module]
    let matchset: (Module?,Module,Module?)
    
    // determine if the rule should be evaluated based on the current context
    func evaluate(_ leftCtx: Module?, _ directCtx: Module, _ rightCtx: Module?) -> Bool {
        return false
    }

    init(_ left: Module?, _ prev: Module, _ right: Module?, _ produces: @escaping (Module?,Module,Module?) -> [Module]) {
        self.matchset = (left,prev,right)
        self.produce = produces
    }

    init(_ left: Module?, _ prev: Module, _ right: Module?, _ produceSingle: @escaping (Module?,Module,Module?) -> Module) {
        self.matchset = (left,prev,right)
        self.produce = { left, prev, right -> [Module] in
            // converts the function that returns a single module into one that
            // returns an array of Module
            let result = produceSingle(left, prev, right)
            return [result]
        }
    }

    init(_ prev: Module, _ produces: @escaping (Module?, Module, Module?) -> [Module]) {
        self.init(nil, prev, nil, produces)
    }

    init(_ prev: Module, _ produceSingle: @escaping (Module?, Module, Module?) -> Module) {
        self.init(nil, prev, nil, produceSingle)
    }

}

public struct LSystem {
    let axiom: Module
    let rules: [Rule]
    
    var state: [Module]
    
    init(_ axiom: Module) {
        self.axiom = axiom
        state = [axiom]
        rules = []
    }
    
    func evolve() -> [Module] {
        var newState:[Module] = []
        for index in 0..<state.count {
            
            let left: Module?
            let strict: Module = state[0]
            let right: Module?
            
            if (index-1>0) {
                left = state[index-1]
            } else {
                left = nil
            }
            
            if (state.count > index+1) {
                right = state[index+1]
            } else {
                right = nil
            }
            
            if rules[0].evaluate(left, strict, right) {
                print("EVAL!")
                newState.append(contentsOf: rules[0].produce(left, strict, right))
            }
        }
        return newState
    }
}

//Example basic Lsys:
//
//    let pythagoras = Lindenmayer(start: "0",
//                                 rules: ["1": "11", "0": "1[-0]+0"],
//                                 variables: ["1": .draw, "0": .draw, "-": .turn(.left, 45), "+": .turn(.right, 45)])
//
//with a dsl:
//
//    Lsys(start: ModuleA()) {
//        Rule(nil,ModuleA.self,nil) { left, direct, right in
//            // this is a 'produces' closure
//            [ModuleB(),BR,Turn(.left, 45),ModuleA(),POP,Turn(.right, 45),ModuleA()]
//        }
//        Rule(nil,ModuleB.self,nil) {
//            [ModuleB(),ModuleB()]
//        }
//    }
//
//    Rule(ModuleB.self) { left, direct, right in
//        ModuleB(direct.value+1)
//    }.when { left, direct, right in
//        // this is a 'conditional' closure
//        direct.value < 10
//    }
//
//}
// ^^ compile time enforcement of things
