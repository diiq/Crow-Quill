import XCTest
@testable import Crow_Quill

class SmoothFixedPenStrokeTests: XCTestCase {
  lazy var renderer = TestRenderer()
  lazy var stroke : Stroke = {
    let points = (1...5).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
    let stroke = SmoothFixedPenStroke(points: points)

    let predictedPoints = (6...8).map {
      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
    }
    stroke.predictedPoints = predictedPoints
    return stroke
  }()

  func testDraw() {
    stroke.draw(renderer)
    XCTAssertEqual(renderer.currentImage, [
      "bezier: <10.0, 50.0>, [<10.0, 50.0>, <16.6666666666667, 50.0>], <20.0, 50.0>",
      "bezier: <20.0, 50.0>, [<23.3333333333333, 50.0>, <26.6666666666667, 50.0>], <30.0, 50.0>",
      "bezier: <30.0, 50.0>, [<33.3333333333333, 50.0>, <36.6666666666667, 50.0>], <40.0, 50.0>",
      "bezier: <40.0, 50.0>, [<43.3333333333333, 50.0>, <46.6666666666667, 50.0>], <50.0, 50.0>",
      "bezier: <50.0, 50.0>, [<53.3333333333333, 50.0>, <56.6666666666667, 50.0>], <60.0, 50.0>",
      "bezier: <60.0, 50.0>, [<63.3333333333333, 50.0>, <66.6666666666667, 50.0>], <70.0, 50.0>",
      "bezier: <70.0, 50.0>, [<73.3333333333333, 50.0>, <80.0, 50.0>], <80.0, 50.0>"],
    "draw() draws both points and predicted points")
  }

  func testDrawPredictedPoints() {
    stroke.drawPredictedPoints(renderer)
    XCTAssertEqual(renderer.currentImage, [
      "bezier: <40.0, 50.0>, [<43.3333333333333, 50.0>, <46.6666666666667, 50.0>], <50.0, 50.0>",
      "bezier: <50.0, 50.0>, [<53.3333333333333, 50.0>, <56.6666666666667, 50.0>], <60.0, 50.0>",
      "bezier: <60.0, 50.0>, [<63.3333333333333, 50.0>, <66.6666666666667, 50.0>], <70.0, 50.0>",
      "bezier: <70.0, 50.0>, [<73.3333333333333, 50.0>, <80.0, 50.0>], <80.0, 50.0>"],
      "drawPredicted() uses the final 3 points plus predicted points")
  }

  func testDrawUndrawnPoints() {
    stroke.undrawnPointIndex = 3
    stroke.drawUndrawnPoints(renderer)
    XCTAssertEqual(renderer.currentImage, [
      "bezier: <20.0, 50.0>, [<23.3333333333333, 50.0>, <26.6666666666667, 50.0>], <30.0, 50.0>",
      "bezier: <30.0, 50.0>, [<33.3333333333333, 50.0>, <36.6666666666667, 50.0>], <40.0, 50.0>"],
      "drawUndrawnPoints() draws the final 3 previously-drawn points plus any new points")
  }
}
