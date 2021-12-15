//
//  Lsystem2DView.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Lindenmayer
import SwiftUI

public struct Lsystem2DView: View {
    let modules: [Module]
    static let renderer = LSystemCGRenderer()
    public var body: some View {
        Canvas { context, size in
//            renderer.draw(<#T##lsystem: LSystem##LSystem#>, into: context, ofSize: size)
            let canvasRect = CGRect(origin: CGPoint(), size: size)
            let path = Lsystem2DView.renderer.path(modules: modules, forRect: canvasRect)
            context.stroke(Path(path),
                           with: GraphicsContext.Shading.color(Color.green))
        }
    }
}

struct Lsystem2DView_Previews: PreviewProvider {
    static let renderer = LSystemCGRenderer()
    static func provideLSystemState() -> [Module] {
        let tree = Lindenmayer.Examples.fractalTree
        do {
            return try tree.evolve(iterations: 3).state
        } catch {
            return []
        }
    }
    static var previews: some View {
        Lsystem2DView(modules: provideLSystemState())
    }
}
