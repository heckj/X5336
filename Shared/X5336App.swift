//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import SceneKit
import SceneKitDebugTools
import SwiftUI

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }

    var model = LSystemModel()

    var body: some Scene {
        WindowGroup {
            VStack {
                LSystemControlView(model: model)
            }
//            Debug3DView()
//            Lsystem3DView(system: Examples3D.hondaTreeBranchingModel.evolved(iterations: 5))
//            ContentView(system: system1)
//            VStack {
//                HStack {
//                    ContentView(system: system1)
//                    ContentView(system: system2)
//                }
//                HStack {
//                    ContentView(system: system3)
//                    ContentView(system: system4)
//                }
//            }
//            DynamicLSystemView()
        }
    }
}
