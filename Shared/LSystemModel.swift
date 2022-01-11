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

    var _scene: SCNScene
    var _transformSequence: [matrix_float4x4]
    
    public var objectWillChange = Combine.ObservableObjectPublisher()

    public var scene: SCNScene {
        get {
            _scene
        }
    }

    public var transformSequence: [matrix_float4x4] {
        get {
            _transformSequence
        }
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
            (_scene, _transformSequence) = renderer.generateScene(lsystem: system)
        }
    }

    public init() {
        system = _baseSystem
        (_scene, _transformSequence) = renderer.generateScene(lsystem: _baseSystem)
    }
}
