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
    func provideLSystemState() -> LSystem {
        var sys = Lindenmayer.Examples.fractalTree //barnsleyFern //dragonCurve //sierpinskiTriangle //kochCurve
        do {
            sys = try sys.evolve(iterations: 6)
        } catch {}
        return sys
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(system: provideLSystemState())
        }
    }
}
