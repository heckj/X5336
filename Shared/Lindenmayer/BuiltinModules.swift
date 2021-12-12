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

struct Internode: Module {
    // This is the thing that I want external developers using the library to be able to create to represent elements within their L-system.
    var name = "I"
    var params: [String: Double] = [:]
    var render2D: RenderCommand = .draw(10) // draws a line 10 units long
}

extension Modules {
    static var internode = Internode()
}
