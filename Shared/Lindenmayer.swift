
import Foundation

public enum LindenmayerDirection: Equatable {
    case right
    case left
}

public enum LindenmayerRule: Equatable, CustomStringConvertible {
    case move
    case draw
    case turn(LindenmayerDirection, Double)
    case storeState
    case restoreState
    case ignore

    public var description: String {
        switch self {
        case .move:
            return "Move"
        case .draw:
            return "Draw"
        case let .turn(.right, angle):
            return "Turn right by \(angle)°"
        case let .turn(.left, angle):
            return "Turn left by \(angle)°"
        case .storeState:
            return "["
        case .restoreState:
            return "]"
        case .ignore:
            return ""
        }
    }
}

public func == (a: LindenmayerDirection, b: LindenmayerDirection) -> Bool {
    switch (a, b) {
    case (.right, .right), (.left, .left):
        return true
    default:
        return false
    }
}

public func == (a: LindenmayerRule, b: LindenmayerRule) -> Bool {
    switch (a, b) {
    case (.move, .move), (.draw, .draw), (.ignore, .ignore), (.storeState, .storeState), (.restoreState, .restoreState):
        return true
    case let (.turn(ad, aa), .turn(bd, ba)) where ad == bd && aa == ba:
        return true
    default:
        return false
    }
}

public struct Lindenmayer {
    var start: String
    var rules: [String: String]
    var variables: [String: LindenmayerRule]

    public init(start: String, rules: [String: String], variables: [String: LindenmayerRule]) {
        self.start = start
        self.rules = rules
        self.variables = variables

        // Add the two default state storing values
        if self.variables["["] == nil {
            self.variables["["] = .storeState
        }

        if self.variables["]"] == nil {
            self.variables["]"] = .restoreState
        }
    }

    ///
    ///  Main Lindenmayer evolution, expands the start
    ///  string by given number of generations
    ///
    ///  :param:    generations - Number of expansions to make
    ///  :returns:  Expanded state
    ///
    public func expandedString(_ generations: Int) -> String {
        return evolve(generations, state: start)
    }

    ///
    ///  Expand the state given number of generations
    ///  and return the produced rules
    ///
    ///  :param:    state - A state to convert
    ///  :returns:  A list of rules that correspond to the state
    ///
    public func expand(_ generations: Int) -> [LindenmayerRule] {
        let state = evolve(generations, state: start)

        var result = [LindenmayerRule]()
        for character in state {
            if let rule = variables[String(character)], rule != .ignore {
                result.append(rule)
            }
        }

        return result
    }

    private func evolve(_ generations: Int, state: String) -> String {
        // End condition for recursion
        if generations < 1 {
            return state
        }

        // Expand each variable with its corresponding rule (or itself)
        var result: String = ""
        for character in state {
            if let rule = rules[String(character)] {
                result += rule
            } else {
                result += String(character)
            }
        }

        return evolve(generations - 1, state: result)
    }
}
