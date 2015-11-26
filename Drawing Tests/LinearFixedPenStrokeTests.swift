import XCTest
@testable import Crow_Quill

class LinearFixedPenStrokeTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var stroke : Stroke = {
    let points = (1...5).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
    return LinearFixedPenStroke(points: points)
  }()
  let line = [
    "line: <10.0, 50.0>, <20.0, 50.0>",
    "line: <20.0, 50.0>, <30.0, 50.0>",
    "line: <30.0, 50.0>, <40.0, 50.0>",
    "line: <40.0, 50.0>, <50.0, 50.0>"]

  func testDrawsAStraightLine() {
    stroke.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line,
      "FixedPenStroke draws a straight line")
  }
}
