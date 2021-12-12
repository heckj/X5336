//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: X5336Document
    let renderer = LSystemCGRenderer()
    var body: some View {
        Lsystem2DView(cgpath: renderer.path(modules: [Internode() as Module]))
            .border(.blue, width: 1.0)
            .padding()
            .border(.red, width: 1.0)
//        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(X5336Document()))
    }
}
