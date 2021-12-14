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
    // This is the kind of thing that I want external developers using the library to be able to create to represent elements within their L-system.
    public var name = "I"
    public var params: [String: Double] = [:]
    public var render2D: RenderCommand = .draw(10) // draws a line 10 units long
}

public struct Branch: Module {
    public var name = "["
    public var params: [String: Double] = [:]
    public var render2D: RenderCommand = .saveState
}

public struct EndBranch: Module {
    public var name = "]"
    public var params: [String: Double] = [:]
    public var render2D: RenderCommand = .restoreState
}

public struct TurnLeft: Module {
    public var name = "-"
    public var params: [String: Double] = [:]
    var angle: Double
    public var render2D: RenderCommand  {
        get {
            .turn(.left, self.angle)
        }
    }
    
    init(_ angle: Double = 90) {
        self.angle = angle
    }
}

public struct TurnRight: Module {
    public var name = "+"
    public var params: [String: Double] = [:]
    var angle: Double
    public var render2D: RenderCommand  {
        get {
            .turn(.right, self.angle)
        }
    }
    
    init(_ angle: Double = 90) {
        self.angle = angle
    }
}

public struct Move: Module {
    public var name = "f"
    public var params: [String: Double] = [:]
    var length: Double
    public var render2D: RenderCommand  {
        get {
            .move(self.length)
        }
    }
    
    init(_ length: Double = 1.0) {
        self.length = length
    }
}

public struct Draw: Module {
    public var name = "F"
    public var params: [String: Double] = [:]
    var length: Double
    public var render2D: RenderCommand  {
        get {
            .draw(self.length)
        }
    }
    
    init(_ length: Double = 1.0) {
        self.length = length
    }
}

public extension Modules {
    static var internode = Internode()
    static var draw = Draw()
    static var move = Move()
    static var turnleft = TurnLeft()
    static var turnright = TurnRight()
    static var branch = Branch()
    static var endbranch = EndBranch()
}
