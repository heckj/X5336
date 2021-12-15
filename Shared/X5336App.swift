//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import SwiftUI

@main
struct X5336App: App {
    //  --> used for a Document based app
//    var body: some Scene {
//        DocumentGroup(newDocument: X5336Document()) { file in
//            ContentView(document: file.$document)
//        }
//    }
    let renderer = LSystemCGRenderer()
    
    func provideLSystemState() -> [Module] {
        var tree = Lindenmayer.Examples.kochCurve
        do {
            try tree.evolve(iterations: 5)
        } catch {}
        return tree.state
    }

    var body: some Scene {
        WindowGroup {
            ContentView(state: provideLSystemState())
        }
    }
}
