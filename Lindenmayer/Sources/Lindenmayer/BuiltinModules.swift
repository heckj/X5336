//
//  BuiltinModules.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

/// A collection of built-in modules for use in LSystems
public struct Modules {}

// MARK: - EXAMPLE MODULE -

public struct Internode: Module {
    // This is the thing that I want external developers using the library to be able to create to represent elements within their L-system.
    public var name = "I"
    public var params: [String: Double] = [:]
    public var render2D: RenderCommand = .draw(10) // draws a line 10 units long
}

public extension Modules {
    static var internode = Internode()
}
