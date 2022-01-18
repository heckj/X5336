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

    var body: some Scene {
        #if os(macOS)
            WindowGroup {
//                system1 =
//                    .evolved(iterations: 10)
                LSystem3DControlView(
                    model: LSystem3DModel(
                        system: Detailed3DExamples.sympodialTree
                            .setParameters(params: Detailed3DExamples.figure2_7A)))
//                Monopodial4Examples()
//                Sympodial4Examples()
//            DynamicLSystemView()
            }
            .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        #else
            WindowGroup {
                NavigationView {
                    Monopodial4Examples()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        #endif
    }
}
