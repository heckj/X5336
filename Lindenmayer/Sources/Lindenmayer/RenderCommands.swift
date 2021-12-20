//
//  RenderCommands.swift
//
//  Created by Joseph Heck on 12/15/21.
//

import Foundation

// MARK: - RENDERING/REPRESENTATION -

public enum TurnDirection: String {
    case right = "-"
    case left = "+"
}

public enum RollDirection: String {
    case left = "\\"
    case right = "/"
}

public enum BendDirection: String {
    case up = "^"
    case down = "&"
}

public struct ColorRepresentation: Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    public init(r: Double, g: Double, b: Double) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = 1.0
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    static var black: ColorRepresentation {
        get {
            return ColorRepresentation(r: 0, g: 0, b: 0)
        }
    }
}
// NOTE(heckj): extensions can't be extended by external developers, so
// if we find we want that, these should instead be set up as static variables
// on a struct, and then we do slightly different case mechanisms.
public enum TwoDRenderCommand : Equatable {
    case move(Double = 1.0) // "f"
    case draw(Double = 1.0) // "F"
    case turn(TurnDirection, Double = 90)
    case saveState // "["
    case restoreState // "]"
    case setLineWidth(Double = 1.0)
    case setLineColor(ColorRepresentation = ColorRepresentation(r: 0.0, g: 0.0, b: 0.0))
    case ignore
}

public enum ThreeDRenderCommand : Equatable {
    case bend(BendDirection, Double = 30)
    case roll(RollDirection, Double = 30)
    case move(Double = 1.0) // "f"
    case cylinder(Double = 1.0, Double = 0.1) // "F" -> cylinder: length, radius
    case sphere(Double = 0.1) // "o" sphere: radius
    case turn(TurnDirection, Double = 90)
    case saveState // "["
    case restoreState // "]"
    case materialColor(ColorRepresentation = ColorRepresentation(r: 0.0, g: 0.0, b: 0.0)) // -> material
    case ignore
}
