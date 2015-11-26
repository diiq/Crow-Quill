import XCTest
@testable import Crow_Quill

class DrawingTests: XCTestCase {
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

  let drawing = Drawing<TestImage>()

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [], "An empty drawing is empty")
  }

  func testAddStrokeToEmpty() {
    drawing.addStroke(stroke)

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line,
      "Adding a single stroke to a drawing draws one stroke")
  }

  func testUndoStroke() {
    drawing.addStroke(stroke)

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line)
    renderer.clear()

    drawing.undoStroke()

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [],
      "Undoing a stroke removes it from the rendered drawing.")

  }

  func testRedoStroke() {
    drawing.addStroke(stroke)

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line)
    renderer.clear()

    drawing.undoStroke()
    drawing.redoStroke()

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line)
  }
}
