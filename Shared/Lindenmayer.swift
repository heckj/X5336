
import Foundation

// Loosely based on the patterned language at
// [Algorithmic Botany](http://algorithmicbotany.org/papers/abop/abop-ch1.pdf)

public enum LindenmayerTurn: Character {
    case right = "_"
    case left = "+"
}

extension LindenmayerTurn: Codable {
    // making the enumeration codable, with assistance from the article at
    // https://blog.untitledkingdom.com/codable-enums-in-swift-3ab3dacf30ce
    // https://jackmorris.xyz/2020/making-enums-codable/
    // https://lostmoa.com/blog/CodableConformanceForSwiftEnumsWithMultipleAssociatedValuesOfDifferentTypes/

    enum TurnCodingKey: CodingKey {
        case raw
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TurnCodingKey.self)
        let rawValue = try container.decode(String.self, forKey: .raw)
        switch rawValue {
        case String(LindenmayerTurn.left.rawValue):
            self = .left
        case String(LindenmayerTurn.right.rawValue):
            self = .right
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TurnCodingKey.self)
        
        switch self {
        case .left:
            try container.encode(String(LindenmayerTurn.left.rawValue), forKey: .raw)
        case .right:
            try container.encode(String(LindenmayerTurn.right.rawValue), forKey: .raw)
        }
    }
}

public enum LindenmayerRoll: Character {
    case left = "\\"
    case right = "/"
}

public enum LindenmayerBend: Character {
    case up = "^"
    case down = "&"
}

public enum LindenmayerRule: CustomStringConvertible {
    case move(Double = 1.0) // "f"
    case draw(Double = 1.0) // "F"
    case turn(LindenmayerTurn, Double = 90)
    case bend(LindenmayerBend, Double = 30)
    case roll(LindenmayerRoll, Double = 30)
    case storeState // "["
    case restoreState // "]"
    case ignore

    public var description: String {
        switch self {
        case let .move(distance):
            return "Move \(distance)"
        case let .draw(distance):
            return "Draw \(distance)"
        case let .turn(.right, angle):
            return "- Turn right by \(angle)°"
        case let .turn(.left, angle):
            return "+ Turn left by \(angle)°"
        case let .bend(.up, angle):
            return "^ Bend up by \(angle)"
        case let .bend(.down, angle):
            return "& Bend down by \(angle)"
        case let .roll(.left, angle):
            return "\\ Roll left by \(angle)"
        case let .roll(.right, angle):
            return "/ Roll right by \(angle)"
        case .storeState:
            return "["
        case .restoreState:
            return "]"
        case .ignore:
            return ""
        }
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
            if let rule = variables[String(character)], String(describing:rule) != "" {
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
