//import XCTest
//@testable import PenAndInk
//
//class UndoFrameTests: XCTestCase {
//  lazy var renderer = TestRenderer()
//  lazy var stroke : Stroke = {
//    let points = (1...5).map {
//      return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
//    }
//    return FixedPenStroke(points: points)
//  }()
//  let frame = UndoFrame<TestImage>(initialImage: ["initial image"])
//  let line = [
//    "line: 10.0, 50.0, 20.0, 50.0",
//    "line: 20.0, 50.0, 30.0, 50.0",
//    "line: 30.0, 50.0, 40.0, 50.0",
//    "line: 40.0, 50.0, 50.0, 50.0"]
//
//  func testDrawsInitialImage() {
//    frame.draw(renderer)
//
//    XCTAssertEqual(renderer.currentImage, ["initial image"], "UndoFrame draws a the initial image")
//  }
//
//  func testAddStroke() {
//    frame.addStroke(stroke)
//    frame.draw(renderer)
//
//    XCTAssertEqual(renderer.currentImage, ["initial image"] + line,
//      "UndoFrame draws the initial image and any strokes")
//  }
//
//  func testMultipleStrokes() {
//    frame.addStroke(stroke)
//    frame.addStroke(stroke)
//    frame.draw(renderer)
//
//    XCTAssertEqual(renderer.currentImage, ["initial image"] + line + line,
//      "UndoFrame draws all added strokes.")
//  }
//}
