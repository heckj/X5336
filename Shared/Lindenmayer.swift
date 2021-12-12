import Foundation
import MurmurHash_Swift
import Squall

// Loosely based on the patterned language at
// [Algorithmic Beauty of Plants](http://algorithmicbotany.org/papers/abop/abop-ch1.pdf)

public enum LindenmayerTurn: String {
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
            try container.encode(LindenmayerTurn.left.rawValue, forKey: .raw)
        case .right:
            try container.encode(LindenmayerTurn.right.rawValue, forKey: .raw)
        }
    }
}

public enum LindenmayerRoll: String {
    case left = "\\"
    case right = "/"
}

public enum LindenmayerBend: String {
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

// protocol L-system
// roughly:
// - axiom (starting point) - string (must be one of the defined modules)
// - modules (rep by a string) - can be defined with parameters (values)
// - rules (list of sequences that match the internal state representation
//   - rules have 3 major elements:
//     - precedence (what's getting rewritten, and mapping to values scoped to the rule for
//       parametric L-systems), and may include directly preceding or following modules for
//       contextual matches of the rule
//     - predicates (parameter specific - provides comparisons of the parametric values in
//       order to determine if a rule should be applied
//     - production - when matched, replaces the element currently at the module
// - rules below matches more to "modules" in ABoP, overlapping with controls that
//   are included for the state representation as part of the rewriting process, but don't
//   themselves represent 'modules' that change and evolve
// - constants [string:value] set

public protocol LSystemsModule {
    var name: String { get }
    var paramcount: UInt { get }
    // should be able to be initialized by a String, and represented by a String
}

public struct LSystemsModuleInstance: LSystemsModule {
    public let name: String
    public let paramcount: UInt = 0
    // should be able to be initialized by a String, and represented by a String
}

public struct LSystemsModuleState {
    var module: LSystemsModuleInstance
    var values: [Double] // length of this should always equal the module.parameters - precondition
}

public struct LSystemsControl: LSystemsModule {
    // ignored in rewriting, provides controls for the Lsystem representation for branching, cutting,
    // twisting, bending, etc.
    public var name: String
    public var paramcount: UInt = 0
}

public struct LSystemsPrecedence {
    var strict: LSystemsModuleInstance
    var strictParameters: [String] = [] // count must match strict.paramcount
    var leftContext: LSystemsModuleInstance?
    var leftParameters: [String] = [] // count must match leftContext.paramcount
    var rightContext: LSystemsModuleInstance?
    var rightParameters: [String] = [] // count must match rightContext.paramcount
    // akin to module, there should be a way to parse this from a string, and create a string representation
    // additionally, each module instance might include a parameter in that string definition that we map out
    // and use within an LSystemsRule
}

public struct LSystemsRule {
    // maybe these 3 things should be in their own struct?
    var precedence: LSystemsPrecedence
    // need a way to identify which params map to variables internal to the rule

    // how do I effectively use/create parameters - need to map each parameter from something in the precedence
    // possibly to something in the predicate, and updated/used in the produces.

    var parameters: [String] // list of parameters used in the rule
    // or maybe this is a working blackboard while we're processing the rule, and should be
    // [String:Double]
    // predicates (specific to Parametric Lsystems)
    var predicate: String // this is where we need to apply parsing magic to "interpret" this string

    // production
    var produces: String
    // more parsing magic needed so that we can create LSystemsModuleInstance using the parameters
    // defined, and create new instances with param values based
}

public struct LsystemDocument {
    // maybe global parameters?
    var axiom: LSystemsModuleInstance
    var constants: [String: Double] = [:]
    // for values that can be used in rules, comparing parameters, etc.
    var modules: [LSystemsModuleInstance] // all the possible modules used in this L-system
    var rules: [LSystemsRule] = []

    var state: [LSystemsModuleState] = []
    var seed: UInt32 // for deterministic stochastic representations with PRNG (Squall)
    // let prng = Squall.seed(seed: self.seed)
    // func init to set up and initialize the L-system into operation
    // func evolve(deltaT: Double) - to iterate through the generations of the rewriting
    // func represent - creates some external representation?
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
            if let rule = variables[String(character)], String(describing: rule) != "" {
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
        var result = ""
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
