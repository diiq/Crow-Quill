import XCTest
@testable import Crow_Quill

class ActiveDrawingTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var points : [StrokePoint] = {
    return (1...5).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
  }()

  let drawing = ActiveDrawing<TestImage, Int>()

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [], "An empty drawing is empty")
  }

  func testAddOrUpdateAdds() {
    XCTAssertEqual(drawing.strokesByIndex.count, 0)
    drawing.addOrUpdateStroke(1, points: points)

    XCTAssertEqual(drawing.strokesByIndex.count, 1,
      "Adding a single stroke to a drawing draws one stroke")
  }

  func testAddOrUpdateUpdates() {
    drawing.addOrUpdateStroke(1, points: points)
    XCTAssertEqual(drawing.strokesByIndex.count, 1)

    drawing.addOrUpdateStroke(1, points: points)

    XCTAssertEqual(drawing.strokesByIndex.count, 1,
      "Updating a stroke doesn't add a new stroke")
  }

  func testUpdateStrokePredictions() {
    drawing.addOrUpdateStroke(1, points: points)
    var predictions = drawing.strokesByIndex[1]?.predictedPoints
    XCTAssertEqual(predictions!.count, 0)

    drawing.updateStrokePredictions(1, points: points)
    predictions = drawing.strokesByIndex[1]?.predictedPoints

    XCTAssertEqual(predictions!.count, points.count,
      "Updating a strokes's predictions sets its predictions")
  }

  func testForgetPredictions() {
    drawing.addOrUpdateStroke(1, points: points)

    drawing.updateStrokePredictions(1, points: points)
    var predictions = drawing.strokesByIndex[1]?.predictedPoints
    XCTAssertEqual(predictions!.count, points.count)

    drawing.forgetPredictions(1)
    predictions = drawing.strokesByIndex[1]?.predictedPoints
    XCTAssertEqual(predictions!.count, 0,
      "Forgetting predictions empties the predictions array for a stroke")
  }

  // endStroke
  // rectForUpdatedPoints
}
