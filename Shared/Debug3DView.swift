//
//  Debug3DView.swift
//  X5336
//
//  Created by Joseph Heck on 12/18/21.
//

import Lindenmayer
import SceneKit
import SceneKitDebugTools
import SwiftUI

extension simd_float4x4 {
    /// Returns a multi-line string that represents the simd4x4 matrix for easier visual reading.
    /// - Parameter indent: If provided, the string to use as a prefix for each line.
    func prettyPrintString(_ indent: String = "") -> String {
        var result = ""
        result += "\(indent)[\(columns.0.x), \(columns.0.y), \(columns.0.z), \(columns.0.w)]\n"
        result += "\(indent)[\(columns.1.x), \(columns.1.y), \(columns.1.z), \(columns.1.w)]\n"
        result += "\(indent)[\(columns.2.x), \(columns.2.y), \(columns.2.z), \(columns.2.w)]\n"
        result += "\(indent)[\(columns.3.x), \(columns.3.y), \(columns.3.z), \(columns.3.w)]\n"
        return result
    }
}

func degreesToRadians(_ value: Double) -> Float {
    return Float(value * .pi / 180.0)
}

func degrees(radians: Float) -> Float {
    return radians / .pi * 180.0
}

func material(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> SCNMaterial {
    let material = SCNMaterial()
    material.diffuse.contents = CGColor(red: red, green: green, blue: blue, alpha: alpha)
    return material
}

func addExampleNode(_ scene: SCNScene) {
    let example = headingIndicator()
    example.name = "example"
    scene.rootNode.addChildNode(example)

//    let fin = SCNNode(geometry: SCNBox(width: 0.1, height: 4, length: 1, chamferRadius: 0))
//    fin.geometry?.materials = [material(red: 1.0, green: 0, blue: 0, alpha: 1)]
//    fin.simdPosition = simd_float3(x: 0, y: 0, z: 0.5)
//    node.addChildNode(fin)

    // Nudge the cylinder "up" so that its bottom is at the "origin" of the transform.
//    node.simdTransform = matrix_multiply(matrix_identity_float4x4, nudgeOriginTransform)

//    node.name = "example"
//    scene.rootNode.addChildNode(node)
//    print(node.simdTransform.prettyPrintString(" nudge "))

    /*
     from honda tree at @V inflection point:

     [-0.5213338, -0.7071067, -0.47771442, 0.0]
     [-0.5213338, 0.7071067, -0.47771442, 0.0]
     [0.6755902, 0.0, -0.7372773, 0.0]
     [-4.692004, 0.76396, -4.29943, 1.0]
     */

//    let exampleTransform = matrix_float4x4([
//        simd_float4(-0.5213338, -0.7071067, -0.47771442, 0.0),
//        simd_float4(-0.5213338, 0.7071067, -0.47771442, 0.0),
//        simd_float4(0.6755902, 0.0, -0.7372773, 0.0),
//        simd_float4(-4.692004, 0.76396, -4.29943, 1.0),
//        // euler angles pitch: -147.05904° yaw: 28.536234° roll: -126.40051°
//    ])
//    node.simdTransform = node.simdTransform * exampleTransform
//    print(node.simdTransform.prettyPrintString(" churn "))
//
//    print("After applying transform")
//    print(node.simdTransform.prettyPrintString("  "))
//    scene.rootNode.addChildNode(node)
}

public struct NodeInfoView: View {
    let node: SCNNode?
    func positionString() -> String {
        var string = "position: "
        if let node = node {
            string += "[\(node.simdPosition.x), \(node.simdPosition.y), \(node.simdPosition.z)]"
        }
        return string
    }

    func anglesString() -> String {
        var string = "euler angles:"
        if let node = node {
            string += "\npitch: \(degrees(radians: node.simdEulerAngles.x))° (\(node.simdEulerAngles.x) rad)"
            string += "\nyaw: \(degrees(radians: node.simdEulerAngles.y))° (\(node.simdEulerAngles.y) rad)"
            string += "\nroll: \(degrees(radians: node.simdEulerAngles.z))° (\(node.simdEulerAngles.z) rad)"
        }
        return string
    }

    func quatString() -> String {
        var string = "rotation: "
        if let node = node {
            string += "[\(node.simdRotation.x),\(node.simdRotation.y),\(node.simdRotation.z),\(node.simdRotation.w)]"
        }
        return string
    }

    public var body: some View {
        VStack {
            Text("Node: \(node?.name ?? "No example node") ")
            if node != nil {
                Text(positionString())
                Text(anglesString())
                Text(quatString())
                Text("")
                Text((node?.simdTransform.prettyPrintString())!)
            }
        }
    }

    public init(node: SCNNode?) {
        self.node = node
    }
}

public struct NodeAdjustmentView: View {
    let node: SCNNode?
    @State private var moreValue: Float = 0
    @State private var textField: String = ""
    @State private var anglesString: String = ""

    public var body: some View {
        VStack {
            TextField("Moar: ", text: $textField)
            HStack {
                Button("add pitch") {
                    if !textField.isEmpty {
                        if let value = Float(textField) {
                            moreValue = value
                        }
                    }
                    if let node = node {
                        let (col1, col2, col3, _) = node.simdTransform.columns
                        let rotationTransform = matrix_float3x3(
                            simd_float3(x: col1.x, y: col1.y, z: col1.z),
                            simd_float3(x: col2.x, y: col2.y, z: col2.z),
                            simd_float3(x: col3.x, y: col3.y, z: col3.z)
                        )
                        print("original: \(node.simdTransform)")
                        print("extracted: \(rotationTransform)")

                        let original_heading_vector = simd_float3(x: 0, y: 1, z: 0)
                        print("Rotated: \(matrix_multiply(rotationTransform, original_heading_vector))")
                        // ^^^^ Heading Vector!!!
                        print("length original: \(simd_length(original_heading_vector))")
                        print("length rotated: \(simd_length(matrix_multiply(rotationTransform, original_heading_vector)))")
                        print("dot product: \(simd_dot(original_heading_vector, matrix_multiply(rotationTransform, original_heading_vector)))")

                        let calc_angle = acos(simd_dot(original_heading_vector, matrix_multiply(rotationTransform, original_heading_vector)) / (simd_length(original_heading_vector) * simd_length(matrix_multiply(rotationTransform, original_heading_vector))))
                        print("Calculated angle from acos(dot/mag): \(calc_angle)")

                        node.simdTransform = node.simdTransform * rotationAroundXAxisTransform(angle: moreValue)
                        var string = "euler angles:"
                        string += "\npitch: \(degrees(radians: node.simdEulerAngles.x))° (\(node.simdEulerAngles.x) rad)"
                        string += "\nyaw: \(degrees(radians: node.simdEulerAngles.y))° (\(node.simdEulerAngles.y) rad)"
                        string += "\nroll: \(degrees(radians: node.simdEulerAngles.z))° (\(node.simdEulerAngles.z) rad)"
                        string += "\n"
                        string += "rot: [\(node.simdRotation.x),\(node.simdRotation.y),\(node.simdRotation.z),\(node.simdRotation.w)]\n"
                        anglesString = string + node.simdTransform.prettyPrintString()
                    }
                }
                Button("add yaw") {
                    if !textField.isEmpty {
                        if let value = Float(textField) {
                            moreValue = value
                        }
                    }
                    if let node = node {
                        node.simdTransform = node.simdTransform * rotationAroundYAxisTransform(angle: moreValue)
                        var string = "euler angles:"
                        string += "\npitch: \(degrees(radians: node.simdEulerAngles.x))° (\(node.simdEulerAngles.x) rad)"
                        string += "\nyaw: \(degrees(radians: node.simdEulerAngles.y))° (\(node.simdEulerAngles.y) rad)"
                        string += "\nroll: \(degrees(radians: node.simdEulerAngles.z))° (\(node.simdEulerAngles.z) rad)"
                        string += "\n"
                        string += "rot: [\(node.simdRotation.x),\(node.simdRotation.y),\(node.simdRotation.z),\(node.simdRotation.w)]\n"
                        anglesString = string + node.simdTransform.prettyPrintString()
                    }
                }
                Button("add roll") {
                    if !textField.isEmpty {
                        if let value = Float(textField) {
                            moreValue = value
                        }
                    }
                    if let node = node {
                        node.simdTransform = node.simdTransform * rotationAroundZAxisTransform(angle: moreValue)

                        var string = "euler angles:"
                        string += "\npitch: \(degrees(radians: node.simdEulerAngles.x))° (\(node.simdEulerAngles.x) rad)"
                        string += "\nyaw: \(degrees(radians: node.simdEulerAngles.y))° (\(node.simdEulerAngles.y) rad)"
                        string += "\nroll: \(degrees(radians: node.simdEulerAngles.z))° (\(node.simdEulerAngles.z) rad)"
                        string += "\n"
                        string += "rot: [\(node.simdRotation.x),\(node.simdRotation.y),\(node.simdRotation.z),\(node.simdRotation.w)]\n"
                        anglesString = string + node.simdTransform.prettyPrintString()
                    }
                }
                Button("interpolate to vertical") {
                    if let node = node {
                        print("")
                        let current = simd_quatf(node.simdTransform)
                        print("  current as quaternion: \(current) (angle: \(current.angle))")

//                        let new_node = SCNNode()
//                        let default_rotation = simd_quatf(new_node.simdTransform)
//                        print ("Default rotation for a new node is : \(default_rotation)")

                        let x = simd_quatf(angle: .pi / 2, axis: simd_float3(x: sqrt(2) / 2, y: 0, z: sqrt(2) / 2))
                        print("x quat: \(x) (angle: \(x.angle))")
                        let northpole = simd_quatf(angle: 0, axis: simd_float3(x: 0, y: 1, z: 0))
                        let southpole = simd_quatf(angle: 0, axis: simd_float3(x: 0, y: -1, z: 0))
                        print("northpole quat: \(northpole) (angle: \(northpole.angle))")
                        print("southpole quat: \(southpole) (angle: \(southpole.angle))")

                        print(" - Interpolated to 0: \(simd_slerp(current, northpole, 0.0)) Θ=\(simd_slerp(current, northpole, 0.0).angle)")
                        print(" - Interpolated to 0.1: \(simd_slerp(current, northpole, 0.1)) Θ=\(simd_slerp(current, northpole, 0.1).angle)")
                        print(" - Interpolated to 0.2: \(simd_slerp(current, northpole, 0.2)) Θ=\(simd_slerp(current, northpole, 0.2).angle)")
                        print(" - Interpolated to 0.3: \(simd_slerp(current, northpole, 0.3)) Θ=\(simd_slerp(current, northpole, 0.3).angle)")
                        print(" - Interpolated to 0.4: \(simd_slerp(current, northpole, 0.4)) Θ=\(simd_slerp(current, northpole, 0.4).angle)")
                        print(" - Interpolated to 0.5: \(simd_slerp(current, northpole, 0.5)) Θ=\(simd_slerp(current, northpole, 0.5).angle)")
                        print(" - Interpolated to 0.6: \(simd_slerp(current, northpole, 0.6)) Θ=\(simd_slerp(current, northpole, 0.6).angle)")
                        print(" - Interpolated to 0.7: \(simd_slerp(current, northpole, 0.7)) Θ=\(simd_slerp(current, northpole, 0.7).angle)")
                        print(" - Interpolated to 0.8: \(simd_slerp(current, northpole, 0.8)) Θ=\(simd_slerp(current, northpole, 0.8).angle)")
                        print(" - Interpolated to 0.9: \(simd_slerp(current, northpole, 0.9)) Θ=\(simd_slerp(current, northpole, 0.9).angle)")
                        print(" - Interpolated to 1.0: \(simd_slerp(current, northpole, 1.0)) Θ=\(simd_slerp(current, northpole, 1.0).angle)")

                        let diffAngleNorthPole = current.conjugate * northpole
                        print("diffAngleQuaterion: \(diffAngleNorthPole)")
                        print("The Φ angle between north pole and current: \(diffAngleNorthPole.angle) with axis: \(diffAngleNorthPole.axis)")

                        let diffAngleSouthPole = current.conjugate * southpole
                        print("diffAngleSouthPole: \(diffAngleSouthPole)")
                        print("The Φ angle between south pole and current: \(diffAngleSouthPole.angle) with axis: \(diffAngleNorthPole.axis)")

                        let interpolation_percentage = .pi / 2.0 / diffAngleNorthPole.angle
                        print("Est. interpolation percentage to get horizon: \(interpolation_percentage)")
                        let new_rotation = simd_slerp(current, northpole, interpolation_percentage)
                        print("final quaternion: \(new_rotation), Θ=\(new_rotation.angle)")
                        node.simdRotation = new_rotation.vector

                        let updated = simd_quatf(node.simdTransform)
                        print("  updated value as quaternion: \(updated) (angle: \(updated.angle))")

                        let diff2AngleNorthPole = updated.conjugate * northpole
                        print("diff2AngleNorthPole: \(diff2AngleNorthPole)")
                        print("The Φ angle between north pole and updated: \(diff2AngleNorthPole.angle) with axis: \(diff2AngleNorthPole.axis)")

                        let diff2AngleSouthPole = updated.conjugate * southpole
                        print("diff2AngleSouthPole: \(diff2AngleSouthPole)")
                        print("The Φ angle between south pole and updated: \(diff2AngleSouthPole.angle) with axis: \(diff2AngleSouthPole.axis)")

                        var string = "updated euler angles:"
                        string += "\npitch: \(degrees(radians: node.simdEulerAngles.x))° (\(node.simdEulerAngles.x) rad)"
                        string += "\nyaw: \(degrees(radians: node.simdEulerAngles.y))° (\(node.simdEulerAngles.y) rad)"
                        string += "\nroll: \(degrees(radians: node.simdEulerAngles.z))° (\(node.simdEulerAngles.z) rad)"
                        string += "\n"
                        string += "rot: [\(node.simdRotation.x),\(node.simdRotation.y),\(node.simdRotation.z),\(node.simdRotation.w)]\n"
                        string += "\n"
                        anglesString = string + node.simdTransform.prettyPrintString()
                    }
                }
            }
            Text("Added \(moreValue)")
            Text(anglesString)
        }
    }

    public init(node: SCNNode?) {
        self.node = node
    }
}

public struct Debug3DView: View {
    static func generateExampleScene() -> SCNScene {
        let scene = SCNScene()
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        cameraNode.simdLook(at: simd_float3(x: 0, y: 5, z: 0))

        // set up debug/sizing flooring
        scene.rootNode.addChildNode(debugFlooring())

        // add example node
        addExampleNode(scene)

        return scene
    }

    let scene: SCNScene

    public var body: some View {
        HStack {
            VStack {
                NodeInfoView(node: scene.rootNode.childNode(withName: "example", recursively: true))
                NodeAdjustmentView(node: scene.rootNode.childNode(withName: "example", recursively: true))
            }
            SceneView(
                scene: scene,
                options: [.allowsCameraControl, .autoenablesDefaultLighting]
            )
        }
    }

    public init() {
        scene = Debug3DView.generateExampleScene()
    }
}

struct Debug3DView_Previews: PreviewProvider {
    static var previews: some View {
        Debug3DView()
    }
}
