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
    let expectedRect = (minX: 10.0, minY: 40.0, maxX: 60.0, maxY: 60.0)
    XCTAssertEqual(rect.minX, expectedRect.minX, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.minY, expectedRect.minY, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.maxX, expectedRect.maxX, "undrawnRect contains all undrawn points")
    XCTAssertEqual(rect.maxY, expectedRect.maxY, "undrawnRect contains all undrawn points")
  }

  func testUndrawnPoints() {
    XCTAssertEqual(stroke.undrawnPoints().count, 5, "no points have been drawn")
    stroke.addPoint(StrokePoint(x: 2, y: 6, weight: 1))
    XCTAssertEqual(stroke.undrawnPoints().count, 2, "there are undrawn points after adding points")
    stroke.draw(renderer)
    XCTAssertEqual(stroke.undrawnPoints().count, 0, "there are no undrawn points after a draw")
  }
}
