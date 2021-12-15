import Lindenmayer
import XCTest

final class HasherPRNGTests: XCTestCase {
    
    func testConsistency_HasherPRNG() throws {
        let seed: UInt32 = 235474323
        var firstResults: [Int] = []
        let subject1 = HasherPRNG(seed: seed)
        for _ in 0...10 {
            firstResults.append(subject1.randomInt())
        }
        
        var secondResults: [Int] = []
        let subject2 = HasherPRNG(seed: seed)
        for _ in 0...10 {
            secondResults.append(subject2.randomInt())
        }
        XCTAssertEqual(firstResults, secondResults)
    }

    func testInconsistency_HasherPRNG() throws {
        let seed: UInt32 = 235474323
        var firstResults: [Int] = []
        let subject1 = HasherPRNG(seed: seed)
        for _ in 0...10 {
            firstResults.append(subject1.randomInt())
        }
        
        var secondResults: [Int] = []
        let subject2 = HasherPRNG(seed: seed+1)
        for _ in 0...10 {
            secondResults.append(subject2.randomInt())
        }
        XCTAssertNotEqual(firstResults, secondResults)
    }

}
