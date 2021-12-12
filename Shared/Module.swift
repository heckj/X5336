//
//  Module.swift
//  X5336
//
//  Created by Joseph Heck on 12/9/21.
//

import Foundation

/// A module represents an element in an L-system state array, and its parameters, if any.
@dynamicMemberLookup
public protocol Module: CustomStringConvertible {
    /// The name of the module.
    ///
    /// Use a single character or very short string for the name, as it's used in textual descriptions of the state of an L-system.
    var name: String { get }

    // By using a map for the parameters, I'm constraining all the parameters
    // to be accessed via a a string, and to be a Double - no integers,
    // Booleans, or random types.
    /// A dictionary that represents the underlying parameters, if any, of the module.
    var params: [String: Double] { get }

    /// Returns the module's parameter defined by the string provided if available; otherwise, nil.
    subscript(dynamicMember _: String) -> Double? {
        get
    }

    var render2D: RenderCommand { get }
    var render3D: RenderCommand { get }
}

extension Module {
    // MARK: - dyanmicMemberLookup default implementation

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
    // MARK: - CustomStringConvertible default implementation

    var description: String {
        return name
    }
}

extension Module {
    // MARK: - Default render command implementations

    var render2D: RenderCommand {
        return .ignore
    }

    var render3D: RenderCommand {
        return .ignore
    }
}
