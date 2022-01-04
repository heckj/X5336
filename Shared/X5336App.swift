//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import SceneKit
import SwiftUI

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }

    let system1: LSystem
    let system2: LSystem
    let system3: LSystem
    let system4: LSystem
    let renderer: SceneKitRenderer

    init() {
//        self.system = Examples3D.randomBush.evolved(iterations: 3)
        var tree = Detailed3DExamples.hondaTree
        tree = tree.reset()
        tree.setParameters(params: Detailed3DExamples.figure2_6A)
        system1 = tree.evolved(iterations: 10)

        tree = tree.reset()
        tree.setParameters(params: Detailed3DExamples.figure2_6B)
        system2 = tree.evolved(iterations: 10)

        tree = tree.reset()
        tree.setParameters(params: Detailed3DExamples.figure2_6C)
        system3 = tree.evolved(iterations: 10)

        tree = tree.reset()
        tree.setParameters(params: Detailed3DExamples.figure2_6D)
        system4 = tree.evolved(iterations: 10)

        renderer = SceneKitRenderer()
    }

    var body: some Scene {
        WindowGroup {
//            Debug3DView()
//            Lsystem3DView(system: Examples3D.hondaTreeBranchingModel.evolved(iterations: 5))
            VStack {
                HStack {
                    ContentView(system: system1)
                    ContentView(system: system2)
                }
                HStack {
                    ContentView(system: system3)
                    ContentView(system: system4)
                }
            }

//            DynamicLSystemView()
        }
    }
}
