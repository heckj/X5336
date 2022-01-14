//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import LindenmayerViews
import SwiftUI

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }

    var model = LSystem3DModel()

    var body: some Scene {
        #if os(macOS)
            WindowGroup {
                VStack {
                    LSystem3DControlView(model: model)
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
            .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        #else
            WindowGroup {
                NavigationView {
                    VStack {
                        LSystem3DControlView(model: model)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        #endif
    }
}
