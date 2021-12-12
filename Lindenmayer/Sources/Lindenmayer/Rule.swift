//
//  Rule.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

/// A rule represents a potential re-writing match to elements within the L-systems state and the closure that provides the elements to be used for the new state elements.
public struct Rule {
    /// The closure that provides the L-system state for the current, previous, and next nodes in the state sequence and expects an array of state elements with which to replace the current state.
    let produce: (Module?, Module, Module?) -> [Module]
    /// The L-system uses these modules to determine is this rule should be applied and re-write the current state.
    let matchset: (Module?, Module, Module?)

    /// Creates a new rule with the extended context and closures you provide that result in a list of state elements.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produces: @escaping (Module?, Module, Module?) -> [Module]) {
        matchset = (left, direct, right)
        produce = produces
    }

    /// Creates a new rule with the extended context and closures you provide that results in a single state element.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produceSingle: @escaping (Module?, Module, Module?) -> Module) {
        matchset = (left, direct, right)
        produce = { left, direct, right -> [Module] in
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