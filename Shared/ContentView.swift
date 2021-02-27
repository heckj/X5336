//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Heck on 2/27/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: X5336Document

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(X5336Document()))
    }
}
