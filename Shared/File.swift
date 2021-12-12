//
//  File.swift
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

// MARK: - EXAMPLE MODULE -

struct Internode: Module {
    // This is the thing that I want external developers using the library to be able to create to represent elements within their L-system.
    var name = "I"
    var params: [String: Double] = [:]
    var render2D: RenderCommand = .draw(10) // draws a line 10 units long
}

// MARK: - RENDERING/REPRESENTATION -

public enum Turn: String {
    case right = "_"
    case left = "+"
}

public enum Roll: String {
    case left = "\\"
    case right = "/"
}

public enum Bend: String {
    case up = "^"
    case down = "&"
}

// NOTE(heckj): extensions can't be extended by external developers, so
// if we find we want that, these should instead be set up as static variables
// on a struct, and then we do slightly different case mechanisms.
public enum RenderCommand {
    case bend(Bend, Double = 30)
    case roll(Roll, Double = 30)
    case move(Double = 1.0) // "f"
    case draw(Double = 1.0) // "F"
    case turn(Turn, Double = 90)
    case saveState // "["
    case restoreState // "]"
    case ignore
}

public struct PathState {
    var angle: Double
    var position: CGPoint

    public init() {
        self.init(0, .zero)
    }

    public init(_ angle: Double, _ position: CGPoint) {
        self.angle = angle
        self.position = position
    }
}

struct CGRenderer {
    let initialState: PathState
    let unitLength: Double

    public init(unitLength: Double = 1) {
        initialState = PathState()
        self.unitLength = unitLength
    }

    public init(initialState: PathState, unitLength: Double) {
        self.initialState = initialState
        self.unitLength = unitLength
    }

    public func path(modules: [Module], forRect destinationRect: CGRect? = nil) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))

        var state: [PathState] = []
        var currentState = initialState

        for module in modules {
            switch module.render2D {
            case .bend:
                break
            case .roll:
                break
            case .move:
                currentState = calculateState(currentState, distance: unitLength)
                path.move(to: currentState.position)
            case .draw:
                currentState = calculateState(currentState, distance: unitLength)
                path.addLine(to: currentState.position)
            case let .turn(direction, angle):
                currentState = calculateState(currentState, angle: angle, direction: direction)
            case .saveState:
                state.append(currentState)
            case .restoreState:
                currentState = state.removeLast()
                path.move(to: currentState.position)
            case .ignore:
                break
            }
        }

        guard let destinationRect = destinationRect else {
            return path
        }

        // Fit the path into our bounds
        var pathRect = path.boundingBox
        let containerRect = destinationRect.insetBy(dx: CGFloat(unitLength), dy: CGFloat(unitLength))

        // First make sure the path is aligned with our origin
        var transform = CGAffineTransform(translationX: -pathRect.minX, y: -pathRect.minY)
        var transformedPath = path.copy(using: &transform)!

        // Next, scale the path to fit snuggly in our path
        pathRect = transformedPath.boundingBoxOfPath
        let scale = min(containerRect.width / pathRect.width, containerRect.height / pathRect.height)
        transform = CGAffineTransform(scaleX: scale, y: scale)
        transformedPath = transformedPath.copy(using: &transform)!

        // Finally, move the path to the correct origin
        transform = CGAffineTransform(translationX: containerRect.minX, y: containerRect.minY)
        transformedPath = transformedPath.copy(using: &transform)!

        return transformedPath
    }

    // MARK: - Private

    func degreesToRadians(_ value: Double) -> Double {
        return value * .pi / 180.0
    }

    func calculateState(_ state: PathState, distance: Double) -> PathState {
        let x = state.position.x + CGFloat(distance * cos(degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(degreesToRadians(state.angle)))

        return PathState(state.angle, CGPoint(x: x, y: y))
    }

    func calculateState(_ state: PathState, angle: Double, direction: Turn)
        -> PathState
    {
        if direction == .left {
            return PathState(state.angle - angle, state.position)
        }

        return PathState(state.angle + angle, state.position)
    }
}

/// A rule represents a potential re-writing match to elements within the L-systems state and the closure that provides the elements to be used for the new state elements.
public struct Rule {
    /// The closure that provides the L-system state for the current, previous, and next nodes in the state sequence and expects an array of state elements with which to replace the current state.
    let produce: (Module?, Module, Module?) -> [Module]
    /// The L-system uses these modules to determine is this rule should be applied and re-write the current state.
    let matchset: (Module?, Module, Module?)

    /// Creates a new rule with the extended context and closures you provide that result in a list of state elements.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produces: @escaping (Module?, Module, Module?) -> [Module]) {
        matchset = (left, direct, right)
        produce = produces
    }

    /// Creates a new rule with the extended context and closures you provide that results in a single state element.
    /// - Parameters:
    ///   - left: The L-system state element prior to the current element that the rule evaluates.
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - right: The L-system state element following the current element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    init(_ left: Module?, _ direct: Module, _ right: Module?, _ produceSingle: @escaping (Module?, Module, Module?) -> Module) {
        matchset = (left, direct, right)
        produce = { left, direct, right -> [Module] in
            // converts the function that returns a single module into one that
            // returns an array of Module
            let result = produceSingle(left, direct, right)
            return [result]
        }
    }

    /// Creates a new rule to match the state element you provide along with a closures that results in a list of state elements.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produces: A closure that produces an array of L-system state elements to use in place of the current element.
    init(_ direct: Module, _ produces: @escaping (Module?, Module, Module?) -> [Module]) {
        self.init(nil, direct, nil, produces)
    }

    /// Creates a new rule to match the state element you provide along with a closures that results in a single state element.
    /// - Parameters:
    ///   - direct: The L-system state element that the rule evaluates.
    ///   - produceSingle: A closure that produces an L-system state element to use in place of the current element.
    init(_ direct: Module, _ produceSingle: @escaping (Module?, Module, Module?) -> Module) {
        self.init(nil, direct, nil, produceSingle)
    }

    /// Determines if a rule should be evaluated while processing the individual atoms of an L-system state sequence.
    /// - Parameters:
    ///   - leftCtx: The atom 'to the left' of the atom being evaluated, if avaialble.
    ///   - directCtx: The current atom to evaluate.
    ///   - rightCtx: The atom 'to the right' of the atom being evaluated, if available.
    /// - Returns: A Boolean value that indicates if the rule should be applied to the current atom within the L-systems state sequence.
    func evaluate(_ leftCtx: Module?, _ directCtx: Module, _ rightCtx: Module?) -> Bool {
        // TODO(heckj): add an additional property that exposes a closure to call
        // to determine if the rule should be evaluated - where the closure exposes
        // access to the internal parameters of the various matched modules - effectively
        // make this a parametric L-system.
        let leftmatch = leftCtx?.name == matchset.0?.name
        let rightmatch = rightCtx?.name == matchset.2?.name
        let directmatch = directCtx.name == matchset.1.name
        return leftmatch && directmatch && rightmatch
    }
}

public struct LSystem {
    let axiom: Module
    let rules: [Rule]

    var state: [Module]

    init(_ axiom: Module) {
        self.axiom = axiom
        // Using [axiom] instead of [] ensures that we always have a state
        // environment that can be evolved based on the rules available.
        state = [axiom]
        rules = []
    }

    func evolve() -> [Module] {
        // Performance is O(n)(z) with the (n) number of atoms in the state and (z) number of rules to apply.
        var newState: [Module] = []
        for index in 0 ..< state.count {
            let left: Module?
            let strict: Module = state[0]
            let right: Module?

            if index - 1 > 0 {
                left = state[index - 1]
            } else {
                left = nil
            }

            if state.count > index + 1 {
                right = state[index + 1]
            } else {
                right = nil
            }
            // Iterate through the rules, finding the first rule to match
            // based on calling 'evaluate' on each of the rules in sequence.
            if rules.first(where: { $0.evaluate(left, strict, right) }) != nil {
                // If a rule was found, then use it to generate the modules that
                // replace this element in the sequence.
                newState.append(contentsOf: rules[0].produce(left, strict, right))
            } else {
                // If no rule was identified, we pass along the 'Module' as an
                // ignored module for later evaluation - for example to be used
                // to represent the final visual state externally.
                newState.append(strict)
            }
        }
        return newState
    }
}
