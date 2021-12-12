//
//  Lsystem2DView.swift
//  X5336
//
//  Created by Joseph Heck on 12/12/21.
//

import Lindenmayer
import SwiftUI

public struct Lsystem2DView: View {
    let cgpath: CGPath
    public var body: some View {
        Canvas { context, _ in
            // context provided is a SwiftUI GraphicsContext
//            context.withCGContext { cgctx in
//                // cgctx is a CoreGraphics.Context
//                cgctx.addPath(path)
//                cgctx.setStrokeColor(CGColor.black)
//                cgctx.setLineWidth(1.0)
//                cgctx.strokePath()
//
//                print(size)
//            }
            context.stroke(Path(cgpath), with: GraphicsContext.Shading.color(Color.green))
        }
    }

    public init(cgpath: CGPath) {
        self.cgpath = cgpath
    }
}

struct Lsystem2DView_Previews: PreviewProvider {
    static let renderer = LSystemCGRenderer()
    static var previews: some View {
        Lsystem2DView(cgpath: renderer.path(modules: [Lindenmayer.Modules.internode as Module]))
    }
}
