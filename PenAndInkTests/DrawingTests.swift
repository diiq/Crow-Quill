import XCTest
@testable import PenAndInk

class DrawingTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var stroke : Stroke = {
    let points = (1...2).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
    return FixedPenStroke(points: points)
  }()

  let drawing = Drawing<TestImage>()

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [], "An empty drawing is empty")
  }

  func testAddStrokeClearsSnapshot() {
    drawing.snapshot = ["CLEAR THIS"]
    drawing.addStroke(stroke)

    XCTAssert(drawing.snapshot == nil,
      "Adding a stroke to a drawing clears the snapshot")
  }

  func testDrawSetsSnapshot() {
    XCTAssert(drawing.snapshot == nil)

    drawing.draw(renderer)

    XCTAssert(drawing.snapshot != nil,
      "draw()ing the Drawing sets the snapshot")

    XCTAssertEqual(drawing.snapshot!, renderer.currentImage,
      "draw()ing the Drawing sets the snapshot to the image")
  }

  func testAddStrokeToEmpty() {
    drawing.addStroke(stroke)

    XCTAssertEqual(drawing.frames.count, 1,
      "Adding a single stroke to an empty drawing adds a frame")

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [
      "line: 10.0, 50.0, 20.0, 50.0"],
      "Adding a single stroke to a drawing draws one stroke")
  }

  func testAddStrokeMakesNewFrame() {
    for _ in 1...drawing.strokesPerFrame {
      drawing.addStroke(stroke)
    }
    XCTAssertEqual(drawing.frames[0].strokes.count, drawing.strokesPerFrame)
    XCTAssertEqual(drawing.frames.count, 1)

    drawing.snapshot = TestImage()
    drawing.addStroke(stroke)
    XCTAssertEqual(drawing.frames.count, 2,
      "Adding a stroke adds a frame, when the current frame is full and the snapshot is up to date")
  }

  func testAddStrokeMakesNoNewFrame() {
    for _ in 1...drawing.strokesPerFrame {
      drawing.addStroke(stroke)
    }
    XCTAssertEqual(drawing.frames[0].strokes.count, drawing.strokesPerFrame)
    XCTAssertEqual(drawing.frames.count, 1)

    drawing.snapshot = nil
    drawing.addStroke(stroke)
    XCTAssertEqual(drawing.frames.count, 1,
      "Adding a stroke adds no new frame, when the snapshot is not up to date")
  }
}
