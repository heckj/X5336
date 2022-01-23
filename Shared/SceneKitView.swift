//
//  SceneView.swift
//  X5336
//
//  Created by Joseph Heck on 1/3/22.
//

import Lindenmayer
import Model3DView
import SceneKit
import SwiftUI

struct SceneKitView: View {
    let scene: SCNScene
    @State var camera1 = PerspectiveCamera()
//    @State var camera2 = OrthographicCamera()

    var body: some View {
        Model3DView(scene: scene)
            .cameraControls(OrbitControls(
                camera: $camera1,
                sensitivity: 0.5,
                friction: 0.1
            ))
    }
}

struct SceneKitView_Previews: PreviewProvider {
    static let renderer = SceneKitRenderer()
    static func provideSystem() -> LindenmayerSystem {
        let evolved: LindenmayerSystem = Examples3D.monopodialTree.evolved(iterations: 5)
        return evolved
    }

    static var previews: some View {
        SceneKitView(scene: renderer.generateScene(lsystem: provideSystem()).0)
    }
}
