//
//  X5336App.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import SwiftUI

@main
struct X5336App: App {
    var body: some Scene {
        DocumentGroup(newDocument: X5336Document()) { file in
            ContentView(document: file.$document)
        }
    }
}
