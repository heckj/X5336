//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import SwiftUI
import Lindenmayer

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }
    let renderer = LSystemCGRenderer()

    var body: some Scene {
        WindowGroup {
            Lsystem2DView(cgpath: renderer.path(modules: [Lindenmayer.Modules.internode as Module]))
        }
    }
}
