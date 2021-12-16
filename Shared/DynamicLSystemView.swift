//
//  SwiftUIView.swift
//  X5336
//
//  Created by Joseph Heck on 12/15/21.
//

import SwiftUI
import Lindenmayer

func provideLSystemState(from sys: LSystemChoice, iterations: Int) -> LSystem {
    var evolved: LSystem
    switch sys {
        case .sierpinskiTriangle:
            evolved = Lindenmayer.Examples.sierpinskiTriangle
        case .kochCurve:
            evolved = Lindenmayer.Examples.kochCurve
        case .dragonCurve:
            evolved = Lindenmayer.Examples.dragonCurve
        case .fractalTree:
            evolved = Lindenmayer.Examples.fractalTree
        case .barnsleyFern:
            evolved = Lindenmayer.Examples.barnsleyFern
    }
    do {
        evolved = try evolved.evolve(iterations: iterations)
    } catch {}
    return evolved
}

enum LSystemChoice: String, CaseIterable, Identifiable {
    case sierpinskiTriangle
    case kochCurve
    case dragonCurve
    case fractalTree
    case barnsleyFern
    var id: String { self.rawValue }
}

struct DynamicLSystemView: View {
    @State private var evolutions: Double = 0
    @State private var selectedSystem = LSystemChoice.fractalTree
    var body: some View {
        VStack {
            Picker("L-System", selection: $selectedSystem) {
                Text("Fractal Tree").tag(LSystemChoice.fractalTree)
                Text("Koch Curve").tag(LSystemChoice.kochCurve)
                Text("Sierpinski Triangle").tag(LSystemChoice.sierpinskiTriangle)
                Text("Dragon Curve").tag(LSystemChoice.dragonCurve)
                Text("Barnsley Fern").tag(LSystemChoice.barnsleyFern)
            }
            .padding()
            HStack {
                Text("Evolutions:")
                Slider(value: $evolutions, in: 0...10.0, step: 1.0) {
                    Text("Evolutions")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                }
            }
            .padding()
            Lsystem2DView(system: provideLSystemState(from: selectedSystem, iterations: Int(evolutions)))
        }
    }
}

struct DynamicLSystemView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicLSystemView()
    }
}
