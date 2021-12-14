//
//  LSystem.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

/// An instance of a parameterized, stochastic Lindenmayer system.
///
/// For more information on the background of Lindenmayer systems, see [Wikipedia's L-System](https://en.wikipedia.org/wiki/L-system).
public struct LSystem {
    let axiom: Module
    let rules: [Rule] // consider making this 'var' and allowing rules to be added after the LSystem is instantiated...
    
    // TODO(heckj): enable global variables/parameters that get injected for consumption within the rule evaluation closures.
    // maybe call it "constants", maybe "globals", maybe "parameters" or "evolution parameters"
    
    var _state: [Module]
    /// The current state of the LSystem, expressed as a sequence of elements that conform to Module.
    public var state: [Module] {
        get {
            return _state
        }
    }
    
    /// Creates a new Lindenmayer system from the axiom and rules you provide.
    /// - Parameters:
    ///   - axiom: A module that represents the initial state of the Lindenmayer system..
    ///   - rules: A collection of rules that the Lindenmayer system applies when you call the evolve function.
    public init(_ axiom: Module, rules:[Rule] = []) {
        self.axiom = axiom
        // Using [axiom] instead of [] ensures that we always have a state
        // environment that can be evolved based on the rules available.
        _state = [axiom]
        self.rules = rules
    }

    @discardableResult
    /// Updates the state of the Lindenmayer system.
    ///
    /// The Lindermayer system iterates through the rules provided, applying the first rule that matches the state from the rule to the current state of the system.
    /// When applying the rule, the element that matched is replaced with what the rule returns from ``Rule/produce``.
    /// The types of errors that may be thrown is defined by any errors referenced and thrown within the set of rules you provide.
    /// - Returns: An updated state for the Lindenmayer system.
    public mutating func evolve() throws -> [Module] {
        // Performance is O(n)(z) with the (n) number of atoms in the state and (z) number of rules to apply.
        // TODO(heckj): revisit this with async methods in mind, creating tasks for each iteration
        // in order to run the whole suite of the state in parallel for a new result. Await the whole
        // kit for a final resolution.
        
        var newState: [Module] = []
        for index in 0 ..< state.count {
            let left: Module?
            let strict: Module = state[0]
            let right: Module?

            if index - 1 > 0 {
                left = state[index - 1]
            } else {
                left = nil
            }

            if state.count > index + 1 {
                right = state[index + 1]
            } else {
                right = nil
            }
            // Iterate through the rules, finding the first rule to match
            // based on calling 'evaluate' on each of the rules in sequence.
            if rules.first(where: { $0.evaluate(left, strict, right) }) != nil {
                // If a rule was found, then use it to generate the modules that
                // replace this element in the sequence.
                newState.append(contentsOf: try rules[0].produce(left, strict, right))
            } else {
                // If no rule was identified, we pass along the 'Module' as an
                // ignored module for later evaluation - for example to be used
                // to represent the final visual state externally.
                newState.append(strict)
            }
        }
        _state = newState
        return newState
    }
}
