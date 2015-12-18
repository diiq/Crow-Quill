import XCTest
@testable import Crow_Quill

class ActiveDrawingTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var points : [Point] = (1...5).map {
    Point(x: 10.0 * Double($0), y: 50.0, weight: 1)
  }

  lazy var predictedPoints : [Point] = (5...10).map {
    Point(x: 10.0 * Double($0), y: 50.0, weight: 1)
  }

  lazy var morePoints : [Point] = (5...10).map {
    Point(x: 10.0 * Double($0), y: 51.0, weight: 1)
  }

  lazy var morePredictedPoints : [Point] = (10...15).map {
    Point(x: 10.0 * Double($0), y: 51.0, weight: 1)
  }

  lazy var drawing: ActiveDrawing<TestImage, Int> = {
    let it = ActiveDrawing<TestImage, Int>()
    it.strokeFactory = LinearFixedPenStroke.init
    return it
  }()

  func testDrawsEmpty() {
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage, [], "An empty drawing is empty")
  }

  func testDrawsUndrawn() {
    drawing.updateStroke(1, points: points, transforms: [])
    drawing.updateStrokePredictions(1, points: predictedPoints)
    drawing.draw(renderer)

    XCTAssertEqual(renderer.currentImage,
      ["move: <10.0, 50.0>", "line: <10.0, 50.0>, <20.0, 50.0>", "line: <20.0, 50.0>, <30.0, 50.0>", "line: <30.0, 50.0>, <40.0, 50.0>", "line: <40.0, 50.0>, <50.0, 50.0>", "stroke", "move: <50.0, 50.0>", "line: <50.0, 50.0>, <50.0, 50.0>", "line: <50.0, 50.0>, <60.0, 50.0>", "line: <60.0, 50.0>, <70.0, 50.0>", "line: <70.0, 50.0>, <80.0, 50.0>", "line: <80.0, 50.0>, <90.0, 50.0>", "line: <90.0, 50.0>, <100.0, 50.0>", "stroke"],
      "Draws initial stroke and predictions")
    XCTAssertEqual(drawing.frozen!, ["move: <10.0, 50.0>", "line: <10.0, 50.0>, <20.0, 50.0>", "line: <20.0, 50.0>, <30.0, 50.0>", "line: <30.0, 50.0>, <40.0, 50.0>", "line: <40.0, 50.0>, <50.0, 50.0>", "stroke"],
      "Frozen image contains only solidified points")
    renderer.clear()
    drawing.forgetPredictions(1)
    drawing.updateStroke(1, points: morePoints, transforms: [])
    drawing.updateStrokePredictions(1, points: morePredictedPoints)
    drawing.draw(renderer)
    XCTAssertEqual(renderer.currentImage, ["move: <10.0, 50.0>", "line: <10.0, 50.0>, <20.0, 50.0>", "line: <20.0, 50.0>, <30.0, 50.0>", "line: <30.0, 50.0>, <40.0, 50.0>", "line: <40.0, 50.0>, <50.0, 50.0>", "stroke", "move: <50.0, 50.0>", "line: <50.0, 50.0>, <50.0, 51.0>", "line: <50.0, 51.0>, <60.0, 51.0>", "line: <60.0, 51.0>, <70.0, 51.0>", "line: <70.0, 51.0>, <80.0, 51.0>", "line: <80.0, 51.0>, <90.0, 51.0>", "line: <90.0, 51.0>, <100.0, 51.0>", "stroke", "move: <100.0, 51.0>", "line: <100.0, 51.0>, <100.0, 51.0>", "line: <100.0, 51.0>, <110.0, 51.0>", "line: <110.0, 51.0>, <120.0, 51.0>", "line: <120.0, 51.0>, <130.0, 51.0>", "line: <130.0, 51.0>, <140.0, 51.0>", "line: <140.0, 51.0>, <150.0, 51.0>", "stroke"],
    "draws the frozen image, any new solidified points, and any new predicted points")

  }

  func testAddOrUpdateAdds() {
    XCTAssertEqual(drawing.strokesByIndex.count, 0)
    drawing.updateStroke(1, points: points, transforms: [])

    XCTAssertEqual(drawing.strokesByIndex.count, 1,
      "Adding a single stroke to a drawing draws one stroke")
  }

  func testAddOrUpdateUpdates() {
    drawing.updateStroke(1, points: points, transforms: [])
    XCTAssertEqual(drawing.strokesByIndex.count, 1)

    drawing.updateStroke(1, points: points, transforms: [])

    XCTAssertEqual(drawing.strokesByIndex.count, 1,
      "Updating a stroke doesn't add a new stroke")
  }

  func testUpdateStrokePredictions() {
    drawing.updateStroke(1, points: points, transforms: [])
    var predictions = drawing.strokesByIndex[1]?.predictedPoints
    XCTAssertEqual(predictions!.count, 0)

    drawing.updateStrokePredictions(1, points: points)
    predictions = drawing.strokesByIndex[1]?.predictedPoints

    XCTAssertEqual(predictions!.count, points.count,
      "Updating a strokes's predictions sets its predictions")
  }

  func testForgetPredictions() {
    drawing.updateStroke(1, points: points, transforms: [])

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
