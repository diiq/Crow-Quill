import XCTest
@testable import Crow_Quill

class WeightedByVelocityTests: XCTestCase {
  lazy var transformation = WeightedByVelocity(scale: 5)
  lazy var points : [StrokePoint] = {
    return (1...5).map {
      return StrokePoint(x: Double($0) * Double($0), y: 50.0, weight: -1)
    }
  }()

  func testWeighting() {
    let actualWeights = transformation.apply(points).map { $0.weight }
    let expectedWeights = [5.0, 5.0, 4.99, 3.57, 2.77]
    print(actualWeights)
    for pair in zip(actualWeights, expectedWeights) {
      XCTAssertEqualWithAccuracy(pair.0, pair.1, accuracy: 0.01)
    }
  }
}

