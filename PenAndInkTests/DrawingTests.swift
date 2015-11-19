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
  let line = [
    "line: 10.0, 50.0, 20.0, 50.0",
    "line: 20.0, 50.0, 30.0, 50.0",
    "line: 30.0, 50.0, 40.0, 50.0",
    "line: 40.0, 50.0, 50.0, 50.0"]

  let drawing = Drawing<TestImage>()

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [], "An empty drawing is empty")
  }

  func testAddStrokeClearsCurrentImage() {
    drawing.currentImage = ["CLEAR THIS"]
    drawing.addStroke(stroke)

    XCTAssert(drawing.currentImage == nil,
      "Adding a stroke to a drawing clears the snapshot")
  }

  func testDrawSetsSnapshot() {
    XCTAssert(drawing.currentImage == nil)

    drawing.draw(renderer)

    XCTAssert(drawing.currentImage != nil,
      "draw()ing the Drawing sets the snapshot")

    XCTAssertEqual(drawing.currentImage!, renderer.currentImage,
      "draw()ing the Drawing sets the snapshot to the image")
  }

  func testAddStrokeToEmpty() {
    drawing.addStroke(stroke)

    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, line,
      "Adding a single stroke to a drawing draws one stroke")
  }

  func testAddStrokeMakesNewSnapshot() {
    for _ in 1...drawing.strokesPerSnapshot {
      drawing.addStroke(stroke)
    }
    XCTAssertEqual(drawing.snapshots.count, 0)

    drawing.currentImage = TestImage()
    drawing.addStroke(stroke)
    XCTAssertEqual(drawing.snapshots.count, 1,
      "Adding a stroke adds a frame, when the current frame is full and the snapshot is up to date")
  }

  func testAddStrokeMakesNoNewSnapshot() {
    for _ in 1...drawing.strokesPerSnapshot {
      drawing.addStroke(stroke)
    }
    XCTAssertEqual(drawing.snapshots.count, 0)

    drawing.currentImage = nil
    drawing.addStroke(stroke)
    XCTAssertEqual(drawing.snapshots.count, 0,
      "Adding a stroke adds no new frame, when the snapshot is not up to date")
  }
}
