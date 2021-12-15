//
//  TwoDTwoDRenderCommands.swift
//  
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

// NOTE(heckj): extensions can't be extended by external developers, so
// if we find we want that, these should instead be set up as static variables
// on a struct, and then we do slightly different case mechanisms.
public enum TwoDRenderCommand : Equatable {
    case bend(BendDirection, Double = 30)
    case roll(RollDirection, Double = 30)
    case move(Double = 1.0) // "f"
    case draw(Double = 1.0) // "F"
    case turn(TurnDirection, Double = 90)
    case saveState // "["
    case restoreState // "]"
    case ignore
}
