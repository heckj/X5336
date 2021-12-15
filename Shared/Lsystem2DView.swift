//
//  Lsystem2DView.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Lindenmayer
import SwiftUI

public struct Lsystem2DView: View {
    let system: LSystem
    static let renderer = LSystemCGRenderer()
    public var body: some View {
        Canvas { context, size in
//            renderer.draw(<#T##lsystem: LSystem##LSystem#>, into: context, ofSize: size)
            let canvasRect = CGRect(origin: CGPoint(), size: size)
            let path = Lsystem2DView.renderer.path(modules: system.state, forRect: canvasRect)
            context.stroke(Path(path),
                           with: GraphicsContext.Shading.color(Color.green))
        }
    }
}

struct Lsystem2DView_Previews: PreviewProvider {
    static var previews: some View {
        Lsystem2DView(system: Examples.barnsleyFarmEvolved)
    }
}
