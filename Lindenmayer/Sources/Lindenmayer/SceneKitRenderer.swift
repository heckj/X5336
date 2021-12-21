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
    var material: SCNMaterial?
    var transform: simd_float4x4

    init(material: SCNMaterial?, transform: simd_float4x4) {
        self.material = material
        self.transform = transform
    }
    
    /// A convenience initializer that locates the growth state at the origin, and without a defined material.
    init() {
        self.init(material: nil,
                  transform: matrix_identity_float4x4)
    }
    
    func applyingTransform(_ transform: simd_float4x4) -> GrowthState {
        let newTransform = matrix_multiply(self.transform, transform)
        return GrowthState(material: self.material, transform: newTransform)
    }

//    func rotateZAxis(_ angle: Float) -> GrowthState {
//        let rows = [
//                simd_float3(cos(angle), -sin(angle), 0),
//                simd_float3(sin(angle), cos(angle), 0),
//                simd_float3(0,          0,          1)
//            ]
//
//        let rotationTransform = simd_float3x3(rows: rows)
//        let updatedTransform = matrix_multiply(self.transform, rotationTransform)
//        return GrowthState(material: self.material, transform: updatedTransform)
//    }
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

            var stateStack: [GrowthState] = []
            var currentState = GrowthState()

            for module in lsystem.state {
                
                // process the 'module.render3D'
                let cmd = module.render3D
                switch cmd {
                case let .bend(direction, angle):
                    print(direction)
                    print(angle)
                case let .roll(direction, angle):
                    print(direction)
                    print(angle)
                case let .move(distance):
//                    print(distance)
                    // use a new SCNNode to calculate the updated transform after
                    // rotation and/or translation in sequence.
                    let calcNode = SCNNode()
                    calcNode.position = SCNVector3(0, distance, 0)
                    currentState = currentState.applyingTransform(calcNode.simdTransform)
                case let .cylinder(length, radius):
                    let node = SCNNode(geometry: SCNCylinder(radius: radius, height: length))
                    node.simdTransform = currentState.transform
//                    print(length)
//                    print(radius)

                    // use a new SCNNode to calculate the updated transform after
                    // rotation and/or translation in sequence.
                    let calcNode = SCNNode()
                    calcNode.position = SCNVector3(0, length, 0)
                    currentState = currentState.applyingTransform(calcNode.simdTransform)
                case let .cone(length, topRadius, bottomRadius):
//                    print(length)
//                    print(topRadius)
//                    print(bottomRadius)
                    let node = SCNNode(geometry: SCNCone(topRadius: topRadius, bottomRadius: bottomRadius, height: length))
                    node.simdTransform = currentState.transform
                    
                    // use a new SCNNode to calculate the updated transform after
                    // rotation and/or translation in sequence.
                    let calcNode = SCNNode()
                    calcNode.position = SCNVector3(0, length, 0)
                    currentState = currentState.applyingTransform(calcNode.simdTransform)
                case let .sphere(radius):
//                    print(radius)
                    let node = SCNNode(geometry: SCNSphere(radius: radius))
                    node.simdTransform = currentState.transform
                    
                    // use a new SCNNode to calculate the updated transform after
                    // rotation and/or translation in sequence.
                    let calcNode = SCNNode()
                    calcNode.position = SCNVector3(0, radius, 0)
                    currentState = currentState.applyingTransform(calcNode.simdTransform)
                case let .turn(direction, angle):
                    print(direction)
                    print(angle)
                case .saveState:
                    stateStack.append(currentState)
                case .restoreState:
                    currentState = stateStack.removeLast()
                case .materialColor(let colorRep):
                    currentState.material = colorRep.material
                case .ignore:
                    break
                }
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

    // MARK: - Internal

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
