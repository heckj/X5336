//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import Model3DView
import SceneKit
import SwiftUI

struct ContentView: View {
    let renderer = SceneKitRenderer()
    let system: LindenmayerSystem
//    @State private var evolutions: Double = 0

//    func evolved(_ system: LSystem, _ iter: Int) -> LSystem {
//        do {
//            return try system.evolve(iterations: iter)
//        } catch {
//            return system
//        }
//    }
//
    var body: some View {
        HStack {
//            VStack {
//                Text("Evolutions:")
//                Slider(value: $evolutions, in: 0 ... 10.0, step: 1.0) {
//                    Text("Evolutions")
//                } minimumValueLabel: {
//                    Text("0")
//                } maximumValueLabel: {
//                    Text("10")
//                }.padding()
//                LSystemMetrics(system: system)
//            }
//            Model3DView(scene: renderer.generateScene(lsystem: evolved(system, Int(evolutions))))
            SceneKitView(scene: renderer.generateScene(lsystem: system).0)
        }
    }
}

// struct DocumentContentView: View {
//    @Binding var document: X5336Document
//    var body: some View {
//        TextEditor(text: $document.text)
//    }
// }

struct ContentView_Previews: PreviewProvider {
    static func generateSystem() -> LindenmayerSystem {
        let evolved: LindenmayerSystem = Examples3D.monopodialTree.evolved(iterations: 5)
        return evolved
    }

    static var previews: some View {
        ContentView(system: generateSystem())
    }
}
