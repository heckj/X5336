//
//  SystemControlView.swift
//  X5336
//
//  Created by Joseph Heck on 1/8/22.
//

import LindenmayerViews
import SceneKitDebugTools
import SwiftUI
import SceneKit

struct LSystemControlView: View {
    var model: LSystemModel
    @State private var iterations = 1
    @State private var stateIndex = 0
    @State private var autoLookAt = false
    var body: some View {
        VStack {
            HStack {
                Stepper {
                    Text("Iterations: \(iterations)")
                } onIncrement: {
                    if iterations < 15 {
                        iterations += 1
                        model.iterations = iterations
                    }
                } onDecrement: {
                    if iterations > 1 {
                        iterations -= 1
                        model.iterations = iterations
                    }
                }
                Toggle(isOn: $autoLookAt) {
                    Text("Look At")
                }
//                Button(role: .none) {
//                    if let material = node.geometry?.firstMaterial {
//                        SCNTransaction.begin()
//                        // on completion, remove the highlight
//                        SCNTransaction.completionBlock = {
//                            SCNTransaction.begin()
//                            SCNTransaction.animationDuration = 0.5
//    #if os(OSX)
//                            material.emission.contents = NSColor.black
//    #elseif os(iOS)
//                            material.emission.contents = UIColor.black
//    #endif
//                            SCNTransaction.commit()
//                        }
//                        // and when we start, highlight with red
//                        SCNTransaction.animationDuration = 0.5
//    #if os(OSX)
//                            material.emission.contents = NSColor.red
//    #elseif os(iOS)
//                            material.emission.contents = UIColor.red
//    #endif
//                        SCNTransaction.commit()
//                } label: {
//                    Text("Animation render update")
//                }
            }
            StateSelectorView(system: model.system, position: $stateIndex)
                .onChange(of: stateIndex) { newValue in
                    if (autoLookAt) {
                        print(newValue)
                        let lookupName = "n\(newValue)"
                        if let selectedNode = model.scene.rootNode.childNode(withName: lookupName, recursively: true) {
                            if let cameraNode = model.scene.rootNode.childNode(withName: "camera", recursively: true) {
                                SCNTransaction.begin()
                                print("Looking at node \(selectedNode)")
                                SCNTransaction.animationDuration = 0.2
                                cameraNode.simdLook(at: selectedNode.simdWorldPosition)
                                SCNTransaction.commit()
                                if let material = selectedNode.geometry?.firstMaterial {
                                    SCNTransaction.begin()
                                    // on completion, remove the highlight
                                    SCNTransaction.completionBlock = {
                                        SCNTransaction.begin()
                                        SCNTransaction.animationDuration = 0.5
                                        #if os(OSX)
                                        material.emission.contents = NSColor.black
                                        #elseif os(iOS)
                                        material.emission.contents = UIColor.black
                                        #endif
                                        SCNTransaction.commit()
                                    }
                                    // and when we start, highlight with red
                                    SCNTransaction.animationDuration = 0.5
                                        #if os(OSX)
                                        material.emission.contents = NSColor.red
                                        #elseif os(iOS)
                                        material.emission.contents = UIColor.red
                                        #endif
                                    SCNTransaction.commit()
                                }

                            }
                        }
                    }
                }
            DebugSceneView(scene: model.scene)
        }
    }
}

struct LSystemControlView_Previews: PreviewProvider {
    static var previews: some View {
        LSystemControlView(model: LSystemModel())
    }
}
