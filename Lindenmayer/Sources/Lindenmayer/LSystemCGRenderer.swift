//
//  LSystemCGRenderer.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import CoreGraphics
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
public enum RenderCommand : Equatable {
    case bend(BendDirection, Double = 30)
    case roll(RollDirection, Double = 30)
    case move(Double = 1.0) // "f"
    case draw(Double = 1.0) // "F"
    case turn(TurnDirection, Double = 90)
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

public struct LSystemCGRenderer {
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
            case .move(let distance):
                currentState = calculateState(currentState, distance: unitLength * distance)
                path.move(to: currentState.position)
            case .draw(let distance):
                currentState = calculateState(currentState, distance: unitLength * distance)
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

    func calculateState(_ state: PathState, angle: Double, direction: TurnDirection)
        -> PathState
    {
        if direction == .left {
            return PathState(state.angle - angle, state.position)
        }

        return PathState(state.angle + angle, state.position)
    }
}
