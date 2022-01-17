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
//                VStack {
//                    LSystem3DControlView(model: model)
//                }
//                Monopodial4Examples()
                Sympodial4Examples()
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
