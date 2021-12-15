//
//  HasherPRNG.swift
//  X5336
//
//  Created by Joseph Heck on 12/15/21.
//

import Foundation

/// A seeded pseudo-random number generator based on Foundation's Hash function.
///
/// Inspiration for this class comes from https://youtu.be/LWFzPP8ZbdU, which suggests
/// that noise functions result in very effect PRNG generators, are exceptionally fast, and generate
/// consistent and deterministic, random numbers.
public final class HasherPRNG: RandomNumberGenerator {
    var hasher: Hasher
    public var position: Int = 0
    var _seed: UInt32
    public var seed: UInt32 {
        get {
            _seed
        }
    }

    public init(seed: UInt32) {
        self.hasher = Hasher()
        self._seed = seed
    }
    
    public func randomInt() -> Int {
        hasher.combine(seed)
        hasher.combine(position)
        let hashValue = hasher.finalize()
        return hashValue
    }
    
    public func next() -> UInt64 {
        hasher.combine(seed)
        hasher.combine(position)
        let hashValue = hasher.finalize()
        return UInt64(hashValue)
    }
}
