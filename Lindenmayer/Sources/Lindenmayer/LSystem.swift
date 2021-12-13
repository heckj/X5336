//
//  LSystem.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

/// An instance of a Lindenmayer system.
public struct LSystem {
    let axiom: Module
    let rules: [Rule]

    var state: [Module]

    public init(_ axiom: Module) {
        self.axiom = axiom
        // Using [axiom] instead of [] ensures that we always have a state
        // environment that can be evolved based on the rules available.
        state = [axiom]
        rules = []
    }

    public func evolve() throws -> [Module] {
        // Performance is O(n)(z) with the (n) number of atoms in the state and (z) number of rules to apply.
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
        return newState
    }
}
