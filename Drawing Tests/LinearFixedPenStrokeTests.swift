import XCTest
import UIKit
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

  func testUndrawnRect() {
    stroke.undrawnPointIndex = 1
    let rect = stroke.undrawnRect()
    let expectedRect = (x: 10.0, y: 40.0, width: 50.0, height: 20.0)
    XCTAssertEqual(rect.x, expectedRect.x, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.y, expectedRect.y, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.width, expectedRect.width, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.height, expectedRect.height, "undrawnRect contains all undrawn points")
  }

  func testUndrawnPoints() {
    XCTAssertEqual(stroke.undrawnPoints().count, 5, "no points have been drawn")
    stroke.addPoint(StrokePoint(x: 2, y: 6, weight: 1))
    XCTAssertEqual(stroke.undrawnPoints().count, 2, "there are undrawn points after adding points")
    stroke.draw(renderer)
    XCTAssertEqual(stroke.undrawnPoints().count, 0, "there are no undrawn points after a draw")
  }
}
