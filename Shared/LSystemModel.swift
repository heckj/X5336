//
//  LSystemModels.swift
//  X5336
//
//  Created by Joseph Heck on 1/8/22.
//

import Combine
import Foundation
import Lindenmayer
import SceneKit
import SwiftUI

public class LSystemModel: ObservableObject {
    @Published public var system: LSystem
    let renderer = SceneKitRenderer()
    let _baseSystem = Detailed3DExamples.sympodialTree

    public var objectWillChange = Combine.ObservableObjectPublisher()

    public var scene: SCNScene {
        renderer.generateScene(lsystem: system)
    }

    var _iterations = 1
    public var iterations: Int {
        get {
            _iterations
        }
        set {
            precondition(newValue > 0 && newValue < 20)
            _iterations = newValue
            objectWillChange.send()
            system = _baseSystem.evolved(iterations: _iterations)
        }
    }

    public init() {
        system = _baseSystem
    }
}
