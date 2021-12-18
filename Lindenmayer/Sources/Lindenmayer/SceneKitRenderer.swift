//
//  SceneKitRenderer.swift
//  
//
//  Created by Joseph Heck on 12/18/21.
//

import Foundation
import CoreGraphics
import SceneKit

struct GrowthState {
    var position: SIMD3<Float> // The node’s position, expressed as x, y, and z translations.
    var eulerAngles: SIMD3<Float> // The node’s orientation, expressed as pitch, yaw, and roll angles in radians.

    init() {
        position = .init()
        eulerAngles = .init()
    }
}

extension ColorRepresentation {
    var material: SCNMaterial {
        get {
            let material = SCNMaterial()
            material.diffuse.contents = CGColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
            return material
        }
    }
}

public struct SceneKitRenderer {
    let lsystem: LSystem
    public init(_ lsystem: LSystem) {
        self.lsystem = lsystem
    }
    
    public var scene: SCNScene {
        get {
            let scene = SCNScene()
            // create and add a camera to the scene
            let cameraNode = SCNNode()
            cameraNode.name = "camera"
            cameraNode.camera = SCNCamera()
            scene.rootNode.addChildNode(cameraNode)

            // place the camera
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 6)

            /*
             // create SCNNode
             let geometry = SCNGeometry(mesh)
             */
            let node = SCNNode(geometry: SCNCapsule())
            scene.rootNode.addChildNode(node)

    //        var state: [GrowthState] = []
    //        var currentState = GrowthState()

            for module in lsystem.state {
                
                // process the 'module.render3D'
                let cmd = module.render3D
    //                switch cmd {
    //                case .move(let distance):
    //                    currentState = updatedStateByMoving(currentState, distance: 1 * distance)
    //                case .draw(let distance):
    //                    let path = CGMutablePath()
    //                    path.move(to: currentState.position)
    //                    currentState = updatedStateByMoving(currentState, distance: 1 * distance)
    //                    path.addLine(to: currentState.position)
    //                    context.stroke(
    //                        Path(path),
    //                        with: GraphicsContext.Shading.color(currentState.lineColor.color),
    //                        lineWidth: currentState.lineWidth)
    //                case let .turn(direction, angle):
    //                    currentState = updatedStateByTurning(currentState, angle: angle, direction: direction)
    //                case .saveState:
    //                    state.append(currentState)
    //                case .restoreState:
    //                    currentState = state.removeLast()
    //                case .ignore:
    //                    break
    //                case let .setLineWidth(width):
    //                    currentState = updatedStateWithLineWidth(currentState, lineWidth: width)
    //                case let .setLineColor(color):
    //                    currentState = updatedStateWithLineColor(currentState, lineColor: color)
    //                }
                
            }
            
            return scene
        }
    }

    // MARK: - Private

    func degreesToRadians(_ value: Double) -> Double {
        return value * .pi / 180.0
    }

    func updatedStateByMoving(_ state: PathState, distance: Double) -> PathState {
        let x = state.position.x + CGFloat(distance * cos(degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(degreesToRadians(state.angle)))

        return PathState(state.angle, CGPoint(x: x, y: y), state.lineWidth, state.lineColor)
    }

    func updatedStateWithLineWidth(_ state: PathState, lineWidth: Double) -> PathState {
        return PathState(state.angle, state.position, lineWidth, state.lineColor)
    }

    func updatedStateWithLineColor(_ state: PathState, lineColor: ColorRepresentation) -> PathState {
        return PathState(state.angle, state.position, state.lineWidth, lineColor)
    }

    func updatedStateByTurning(_ state: PathState, angle: Double, direction: TurnDirection)
        -> PathState
    {
        if direction == .left {
            return PathState(state.angle - angle, state.position, state.lineWidth, state.lineColor)
        }

        return PathState(state.angle + angle, state.position, state.lineWidth, state.lineColor)
    }
}
