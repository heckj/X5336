//
//  LSystemCGRenderer.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import CoreGraphics
import SwiftUI

struct PathState {
    var angle: Double
    var position: CGPoint
    var lineWidth: Double
    var lineColor: CGColor

    public init(_ angle: Double = 0, _ position: CGPoint = .zero, _ lineWidth: Double = 1.0, _ lineColor: CGColor = .black) {
        self.angle = angle
        self.position = position
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
}

public struct LSystemCGRenderer {
    let initialState: PathState
    let unitLength: Double

    public init(unitLength: Double = 1) {
        initialState = PathState()
        self.unitLength = unitLength
    }

    public func draw(_ lsystem: LSystem, into context: GraphicsContext, ofSize size: CGSize) {
        // context provided is a SwiftUI GraphicsContext
        //            context.withCGContext { cgctx in
        //                // cgctx is a CoreGraphics.Context
        //                cgctx.addPath(path)
        //                cgctx.setStrokeColor(CGColor.black)
        //                cgctx.setLineWidth(1.0)
        //                cgctx.strokePath()
        //
        //                print(size)
        //            }

        

        var state: [PathState] = []
        var currentState = initialState

        for module in lsystem.state {
            for cmd in module.render2D {
                switch cmd {
                case .bend:
                    break
                case .roll:
                    break
                case .move(let distance):
                    currentState = updatedStateByMoving(currentState, distance: unitLength * distance)
                case .draw(let distance):
                    let path = CGMutablePath()
                    path.move(to: currentState.position)
                    currentState = updatedStateByMoving(currentState, distance: unitLength * distance)
                    path.addLine(to: currentState.position)
                    context.stroke(
                        Path(path),
                        with: GraphicsContext.Shading.color(Color(currentState.lineColor)),
                        lineWidth: currentState.lineWidth)
                case let .turn(direction, angle):
                    currentState = updatedStateByTurning(currentState, angle: angle, direction: direction)
                case .saveState:
                    state.append(currentState)
                case .restoreState:
                    currentState = state.removeLast()
                case .ignore:
                    break
                case .setLineWidth(_):
                    break
                case .setLineColor(_):
                    break
                }
            }
        }
    }
    
    /// Returns a Core Graphics path representing the set of modules, ignoring line weights and colors.
    /// - Parameters:
    ///   - modules: The modules that make up the state of an LSystem.
    ///   - destinationRect: An optional rectangle that, if provided, the path will be scaled into.
    /// - Returns: The path that draws the 2D representation of the provided LSystem modules.
    public func path(modules: [Module], forRect destinationRect: CGRect? = nil) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))

        var state: [PathState] = []
        var currentState = initialState

        for module in modules {
            for cmd in module.render2D {
                switch cmd {
                case .bend:
                    break
                case .roll:
                    break
                case .move(let distance):
                    currentState = updatedStateByMoving(currentState, distance: unitLength * distance)
                    path.move(to: currentState.position)
                case .draw(let distance):
                    currentState = updatedStateByMoving(currentState, distance: unitLength * distance)
                    path.addLine(to: currentState.position)
                case let .turn(direction, angle):
                    currentState = updatedStateByTurning(currentState, angle: angle, direction: direction)
                case .saveState:
                    state.append(currentState)
                case .restoreState:
                    currentState = state.removeLast()
                    path.move(to: currentState.position)
                case .ignore:
                    break
                case .setLineWidth(_):
                    break
                case .setLineColor(_):
                    break
                }
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

    func updatedStateByMoving(_ state: PathState, distance: Double) -> PathState {
        let x = state.position.x + CGFloat(distance * cos(degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(degreesToRadians(state.angle)))

        return PathState(state.angle, CGPoint(x: x, y: y))
    }

    func updatedStateByTurning(_ state: PathState, angle: Double, direction: TurnDirection)
        -> PathState
    {
        if direction == .left {
            return PathState(state.angle - angle, state.position)
        }

        return PathState(state.angle + angle, state.position)
    }
}
