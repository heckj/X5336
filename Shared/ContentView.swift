//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import Lindenmayer
import SwiftUI

struct ContentView: View {
    let renderer = LSystemCGRenderer()
    var body: some View {
        VStack {
            Text("Lindenmayer")
                .padding()
            Lsystem2DView(cgpath: renderer.path(modules: [Lindenmayer.Modules.internode as Module]))
                .border(Color.red)
                .padding()
            
        }
    }
        
}

struct DocumentContentView: View {
    @Binding var document: X5336Document
    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
