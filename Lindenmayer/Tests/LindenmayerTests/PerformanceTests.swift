import Lindenmayer
import XCTest

final class PerformanceTests: XCTestCase {

    func X_testMemoryUse() {
        self.measure(metrics: [XCTMemoryMetric()]) {
            do {
                let tree = Lindenmayer.Examples.barnsleyFern
                let evo1 = try tree.evolve(iterations: 6)
                XCTAssertNotNil(evo1)
            } catch {}
        }
    }

    func X_testEvolutionSpeed() {
        self.measure() {
            do {
                // 20.675 seconds
                let tree = Lindenmayer.Examples.barnsleyFern
                let evo1 = try tree.evolve(iterations: 10)
                XCTAssertNotNil(evo1)
            } catch {}
        }
    }

}
