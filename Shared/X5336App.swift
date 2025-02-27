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

    var body: some Scene {
        #if os(macOS)
            WindowGroup {
//                RollToVerticalTestView()

//                LSystem3DControlView(
//                    model: LSystem3DModel(
//                        system: Detailed3DExamples.sympodialTree
//                            .setParameters(params: Detailed3DExamples.figure2_7A)))

//                                Monopodial4Examples()
//                                Sympodial4Examples()
                Dynamic2DLSystemViews()
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
