//
//  BuiltinModules.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Foundation

/// A collection of built-in modules for use in LSystems
public enum Modules { }

public extension Modules {
    // MARK: - EXAMPLE MODULE -

    struct Internode: Module {
        // This is the kind of thing that I want external developers using the library to be able to create to represent elements within their L-system.
        public var name = "I"
        public var render2D: RenderCommand = .draw(10) // draws a line 10 units long
    }
    static var internode = Internode()
    
    // MARK: - BUILT-IN 2D FOCUSED MODULES -

    struct Branch: Module {
        public var name = "["
        public var render2D: RenderCommand = .saveState
    }
    static var branch = Branch()

    struct EndBranch: Module {
        public var name = "]"
        public var render2D: RenderCommand = .restoreState
    }
    static var endbranch = EndBranch()

    struct TurnLeft: Module {
        public var name = "-"
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
    static var turnleft = TurnLeft()


    struct TurnRight: Module {
        public var name = "+"
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
    static var turnright = TurnRight()


    struct Move: Module {
        public var name = "f"
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
    static var move = Move()

    struct Draw: Module {
        public var name = "F"
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
    static var draw = Draw()

}
