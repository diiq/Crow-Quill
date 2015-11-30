import XCTest
@testable import Crow_Quill

class WeightedByVelocityTests: XCTestCase {
  lazy var transformation = WeightedByVelocity(scale: 100)
  lazy var points : [StrokePoint] = {
    return (1...5).map {
      return StrokePoint(x: 10 * Double($0) * Double($0), y: 50.0, weight: Double($0))
    }
  }()

  func testWeighting() {
    let actualWeights = transformation.apply(points).map { $0.weight }
    let expectedWeights = [33.32, 33.32, 20.0, 14.28, 11.11]
    for pair in zip(actualWeights, expectedWeights) {
      XCTAssertEqualWithAccuracy(pair.0, pair.1, accuracy: 0.01)
    }
  }
}

