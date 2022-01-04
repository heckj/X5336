//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import SwiftUI
import SceneKit

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }
    
    let system: LSystem
    let renderer: SceneKitRenderer
    
    init() {
//        self.system = Examples3D.randomBush.evolved(iterations: 3)
        self.system = Examples3D.hondaTreeBranchingModel.lsystem.evolved(iterations: 10)
        self.renderer = SceneKitRenderer()
    }
    
    var body: some Scene {
        WindowGroup {
//            Debug3DView()
//            Lsystem3DView(system: Examples3D.hondaTreeBranchingModel.evolved(iterations: 5))
            ContentView(system: system)
//            DynamicLSystemView()
        }
    }
}
