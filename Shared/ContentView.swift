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
    let state: [Module]
    var body: some View {
        VStack {
            Text("Lindenmayer")
                .padding()
            Lsystem2DView(modules: state)
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
        ContentView(state: [])
    }
}
