//
//  File.swift
//  X5336
//
//  Created by Joseph Heck on 12/9/21.
//

import Foundation

/// A module represents an element in an L-system state array, and its parameters, if any.
@dynamicMemberLookup
public protocol Module : CustomStringConvertible {
    /// The name of the module.
    ///
    /// Use a single character or very short string for the name, as it's used in textual descriptions of the state of an L-system.
    var name: String { get }
    
    // By using a map for the parameters, I'm constraining all the parameters
    // to be accessed via a a string, and to be a Double - no integers,
    // Booleans, or random types.
    /// A dictionary that represents the underlying parameters, if any, of the module.
    var params: [String:Double] { get }
    
    /// Returns the module's parameter defined by the string provided if available; otherwise, nil.
    subscript(dynamicMember member: String) -> Double? {
        get
    }
    // and maybe something to evaluate the rule into a 2D or 3D representation
}

extension Module {
    // - dyanmicMemberLookup default implementation
    // Q(heckj): Is this worth it?
    
    subscript(dynamicMember member: String) -> Double? {
        if params.keys.contains(member) {
            return params[member]
        } else {
            return nil
        }
    }
}

extension Module {
    // - CustomStringConvertible default implementation
    
    var description: String {
        return name
    }
}

// - EXAMPLE MODULE -

struct Internode: Module {
    // This is the thing that I want external developers using the library to be able to create to represent elements within their L-system.
    var name = "I"
    var params: [String:Double] = [:]
}

/// A rule represents a potential re-writing match to elements within the L-systems state and the closure that provides the elements to be used for the new state elements.
public struct Rule {
    /// The closure that provides the L-system state for the current, previous, and next nodes in the state sequence and expects an array of state elements with which to replace the current state.
    let produce: (Module?,Module,Module?) -> [Module]
    /// The L-system uses these modules to determine is this rule should be applied and re-write the current state.
    let matchset: (Module?,Module,Module?)
    
    
    /// Creates a new rule with the extended context and closures you provide that result in a list of state elements.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produces: @escaping (Module?,Module,Module?) -> [Module]) {
        self.matchset = (left,direct,right)
        self.produce = produces
    }
    
    /// Creates a new rule with the extended context and closures you provide that results in a single state element.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produceSingle: @escaping (Module?,Module,Module?) -> Module) {
        self.matchset = (left,direct,right)
        self.produce = { left, direct, right -> [Module] in
            // converts the function that returns a single module into one that
            // returns an array of Module
            let result = produceSingle(left, direct, right)
            return [result]
        }
    }
    
    /// Creates a new rule to match the state element you provide along with a closures that results in a list of state elements.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    init(_ direct: Module, _ produces: @escaping (Module?, Module, Module?) -> [Module]) {
        self.init(nil, direct, nil, produces)
    }
    
    /// Creates a new rule to match the state element you provide along with a closures that results in a single state element.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    init(_ direct: Module, _ produceSingle: @escaping (Module?, Module, Module?) -> Module) {
        self.init(nil, direct, nil, produceSingle)
    }

    /// Determines if a rule should be evaluated while processing the individual atoms of an L-system state sequence.
    /// - Parameters:
    ///   - leftCtx: The atom 'to the left' of the atom being evaluated, if avaialble.
    ///   - directCtx: The current atom to evaluate.
    ///   - rightCtx: The atom 'to the right' of the atom being evaluated, if available.
    /// - Returns: A Boolean value that indicates if the rule should be applied to the current atom within the L-systems state sequence.
    func evaluate(_ leftCtx: Module?, _ directCtx: Module, _ rightCtx: Module?) -> Bool {
        // TODO(heckj): add an additional property that exposes a closure to call
        // to determine if the rule should be evaluated - where the closure exposes
        // access to the internal parameters of the various matched modules - effectively
        // make this a parametric L-system.
        let leftmatch = leftCtx?.name == matchset.0?.name
        let rightmatch = rightCtx?.name == matchset.2?.name
        let directmatch = directCtx.name == matchset.1.name
        return leftmatch && directmatch && rightmatch
    }

}

public struct LSystem {
    let axiom: Module
    let rules: [Rule]
    
    var state: [Module]
    
    init(_ axiom: Module) {
        self.axiom = axiom
        // Using [axiom] instead of [] ensures that we always have a state
        // environment that can be evolved based on the rules available.
        state = [axiom]
        rules = []
    }
    
    func evolve() -> [Module] {
        // Performance is O(n)(z) with the (n) number of atoms in the state and (z) number of rules to apply.
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
            // Iterate through the rules, finding the first rule to match
            // based on calling 'evaluate' on each of the rules in sequence.
            if rules.first(where: { $0.evaluate(left, strict, right) }) != nil {
                // If a rule was found, then use it to generate the modules that
                // replace this element in the sequence.
                newState.append(contentsOf: rules[0].produce(left, strict, right))
            } else {
                // If no rule was identified, we pass along the 'Module' as an
                // ignored module for later evaluation - for example to be used
                // to represent the final visual state externally.
                newState.append(strict)
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


/*
 Representation options:
 - UIKit - CoreGraphics
 - AppKit - COreGraphics
 - both - MetalKit
   - https://developer.apple.com/documentation/metalkit/mtkview
 - both - SwiftUI canvas
   - https://developer.apple.com/documentation/swiftui/canvas
   - https://developer.apple.com/documentation/swiftui/graphicscontext
   - https://betterprogramming.pub/implementing-swiftui-canvas-view-in-ios-15-b7909eac207
 
 - both - 3D w/ Scenekit
   - https://developer.apple.com/documentation/scenekit/
   - https://litoarias.medium.com/scenekit-to-show-3d-content-in-swift-5-5253afbe63b1
 - ios/both? - 3D w/ RealityKit

I think in each of these cases, we want to pass the graphics rendering context (or scene?) into the "LsystemRep" to get the relevant things drawn.
 The default should probably be SwiftUI's [GraphicsContext](https://developer.apple.com/documentation/swiftui/graphicscontext).
 It also provides a [CoreGraphics proxy](https://developer.apple.com/documentation/swiftui/graphicscontext/withcgcontext(content:)) that we can use to draw into the context - at least if we don't want to use SwiftUI's drawing primitives.
 
 */
