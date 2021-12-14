//
//  ExampleLSystems.swift
//  
//
//  Created by Joseph Heck on 12/14/21.
//

import Foundation

public enum Examples {
    
}


public extension Examples {
    
    func xx() {
        let y = A.self // -> A.Type
        print(y)
    }
    
    // - MARK: Algae example
    struct A: Module {
        public var name = "A"
    }
    static var a = A()
    struct B: Module {
        public var name = "B"
    }
    static var b = B()

    static var algae = LSystem(a, rules: [
        ConcreteRule(a, { _, _, _ in
            [a,b]
        }),
        ConcreteRule(b, { _, _, _ in
            [a]
        })
    ])
}
