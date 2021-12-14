//
//  Rule.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

//public enum RuleFailure: Error {
//    case downcastFailure(m: Module) = "Error downcasting Module[]"
//}

public struct RuntimeError<T:Module>: Error {
    let message: String

    public init(_ t: Module) {
        self.message = "Downcasting failure on module \(t.description)"
    }

    public var localizedDescription: String {
        return message
    }
    
}

/// A rule represents a potential re-writing match to elements within the L-systems state and the closure that provides the elements to be used for the new state elements.
public protocol Rule: CustomStringConvertible {
    
    /// The set of types that this rule matches.
    var matchset:(Module?, Module, Module?) {
        get
    }
    
    /// A closure that you provide which defines the modules to provide in place of the evaluated module.
    var produce: (Module?, Module, Module?) throws -> [Module] {
        get
    }
    
    /// Returns a Boolean value that indicates whether the rule matches the context provided.
    func evaluate(_ leftCtx: Module?, _ directCtx: Module, _ rightCtx: Module?) -> Bool
    
    // ?? do I need 'init' on the protocol as well?
}

extension Rule {
    
    /// A description of the rule that details what it matches
    public var description: String {
        return "Rule[matching \(matchset)]"
    }
}

/// A concrete implementation of Rule
public struct ConcreteRule: Rule {
    
    /// The closure that provides the L-system state for the current, previous, and next nodes in the state sequence and expects an array of state elements with which to replace the current state.
    public let produce: (Module?, Module, Module?) throws -> [Module]
    
    /// The L-system uses these modules to determine is this rule should be applied and re-write the current state.
    public let matchset: (Module?, Module, Module?)

    // it seems like it might be better to use the type of the module for providing the
    // matchsets...
    //    let y = A.self // -> A.Type

    /// Creates a new rule with the extended context and closures you provide that result in a list of state elements.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    public init(_ left: Module?, _ direct: Module, _ right: Module?, _ produces: @escaping (Module?, Module, Module?) throws -> [Module]) {
        matchset = (left, direct, right)
        produce = produces
    }

    /// Creates a new rule with the extended context and closures you provide that results in a single state element.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    public init(_ left: Module?, _ direct: Module, _ right: Module?, _ produceSingle: @escaping (Module?, Module, Module?) throws -> Module) {
        matchset = (left, direct, right)
        produce = { left, direct, right -> [Module] in
            // converts the function that returns a single module into one that
            // returns an array of Module
            let result = try produceSingle(left, direct, right)
            return [result]
        }
    }

    /// Creates a new rule to match the state element you provide along with a closures that results in a list of state elements.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    public init(_ direct: Module, _ produces: @escaping (Module?, Module, Module?) throws -> [Module]) {
        self.init(nil, direct, nil, produces)
    }

    /// Creates a new rule to match the state element you provide along with a closures that results in a single state element.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    public init(_ direct: Module, _ produceSingle: @escaping (Module?, Module, Module?) throws -> Module) {
        self.init(nil, direct, nil, produceSingle)
    }

    /// Determines if a rule should be evaluated while processing the individual atoms of an L-system state sequence.
    /// - Parameters:
    ///   - leftCtx: The atom 'to the left' of the atom being evaluated, if avaialble.
    ///   - directCtx: The current atom to evaluate.
    ///   - rightCtx: The atom 'to the right' of the atom being evaluated, if available.
    /// - Returns: A Boolean value that indicates if the rule should be applied to the current atom within the L-systems state sequence.
    public func evaluate(_ leftCtx: Module?, _ directCtx: Module, _ rightCtx: Module?) -> Bool {
        // TODO(heckj): add an additional property that exposes a closure to call
        // to determine if the rule should be evaluated - where the closure exposes
        // access to the internal parameters of the various matched modules - effectively
        // make this a parametric L-system.
        
        // short circuit if the direct context doesn't match the matchset's setting
        guard type(of: matchset.1) == type(of: directCtx) else {
            return false
        }

        // The left matchset _can_ be nil, but if it's provided, try to match against it.
        let leftmatch: Bool
        // First unwrap the type if we can, because an Optional<Foo> won't match Foo...
        if let unwrapedLeft = matchset.0 {
            leftmatch = type(of: unwrapedLeft) == type(of: leftCtx)
        } else {
            leftmatch = true
        }

        // The right matchset _can_ be nil, but if it's provided, try to match against it.
        let rightmatch: Bool
        // First unwrap the type if we can, because an Optional<Foo> won't match Foo...
        if let unwrapedRight = matchset.2 {
            rightmatch = type(of: unwrapedRight) == type(of: rightCtx)
        } else {
            rightmatch = true
        }
                
        return leftmatch && rightmatch
    }
}
