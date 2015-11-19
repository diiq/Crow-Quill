import XCTest
@testable import PenAndInk

class DrawingTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var stroke : Stroke = {
    let points = (1...5).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
    return FixedPenStroke(points: points)
  }()

  let drawing = Drawing<TestImage>(strokesPerFrame: 2)

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.image, [], "An empty drawing is empty")
  }

  func testAddStroke() {

  }
}
