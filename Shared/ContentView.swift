//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import SwiftUI
import Model3DView
import SceneKit

struct ContentView: View {
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
//        Model3DView(scene: scene)
//        .cameraControls(OrbitControls(
//            camera: $camera2,
//            sensitivity: 0.5,
//            friction: 0.1
//        ))
    }
}

//struct DocumentContentView: View {
//    @Binding var document: X5336Document
//    var body: some View {
//        TextEditor(text: $document.text)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static func generateScene() -> SCNScene {
        return SceneKitRenderer(Lindenmayer.Examples3D.hondaTreeBranchingModel.evolved(iterations: 5)).scene
    }

    static var previews: some View {
        ContentView(scene: self.generateScene())
    }
}
