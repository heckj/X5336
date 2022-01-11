//
//  SystemControlView.swift
//  X5336
//
//  Created by Joseph Heck on 1/8/22.
//

import LindenmayerViews
import SceneKitDebugTools
import SwiftUI

struct LSystemControlView: View {
    var model: LSystemModel
    @State private var iterations = 1
    @State private var stateIndex = 0
    var body: some View {
        VStack {
            Stepper {
                Text("\(iterations)")
            } onIncrement: {
                if iterations < 15 {
                    iterations += 1
                    model.iterations = iterations
                }
            } onDecrement: {
                if iterations > 1 {
                    iterations -= 1
                    model.iterations = iterations
                }
            }
            StateSelectorView(system: model.system, position: $stateIndex)
            DebugSceneView(scene: model.scene)
        }
    }
}

struct LSystemControlView_Previews: PreviewProvider {
    static var previews: some View {
        LSystemControlView(model: LSystemModel())
    }
}
