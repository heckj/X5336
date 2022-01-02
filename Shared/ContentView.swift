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
    let system: LSystem
    let renderer = SceneKitRenderer()
    @State var camera1 = PerspectiveCamera()
    @State private var evolutions: Double = 0
//    @State var camera2 = OrthographicCamera()

    func evolved(_ system: LSystem, _ iter: Int) -> LSystem {
        do {
            return try system.evolve(iterations: iter)
        } catch {
            return system
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Evolutions:")
                Slider(value: $evolutions, in: 0 ... 10.0, step: 1.0) {
                    Text("Evolutions")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                }.padding()
                LSystemMetrics(system: system)
            }
            Model3DView(scene: renderer.generateScene(lsystem: evolved(system, Int(evolutions))))
            .cameraControls(OrbitControls(
                camera: $camera1,
                sensitivity: 0.5,
                friction: 0.1
            ))
        }
    }
}

//struct DocumentContentView: View {
//    @Binding var document: X5336Document
//    var body: some View {
//        TextEditor(text: $document.text)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static func generateSystem() -> LSystem {
        return Examples3D.hondaTreeBranchingModel.evolved(iterations: 5)
    }

    static var previews: some View {
        ContentView(system: generateSystem())
    }
}
