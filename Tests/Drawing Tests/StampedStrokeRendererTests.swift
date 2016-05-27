  import XCTest
  @testable import Crow_Quill
  
  class TestStampedRendererTests: XCTestCase {
    let renderer = TestRenderer()
    func testDrawsStampedLine() {
      func stamper(point: Point, renderer: Renderer) {
        renderer.circle(point, radius: point.weight)
      }
      
      renderer.stampedLine(start: Point(x: 0, y: 0, weight: 1), end: Point(x: 0, y: 1, weight: 5), stamper: stamper, minimumGap: 0.1)
      
      XCTAssertEqual(renderer.currentImage, [
        "circle: <0.0, 0.5>, 3.0",
        "circle: <0.0, 0.25>, 2.0",
        "circle: <0.0, 0.125>, 1.5",
        "circle: <0.0, 0.0625>, 1.25",
        "circle: <0.0, 0.1875>, 1.75",
        "circle: <0.0, 0.375>, 2.5",
        "circle: <0.0, 0.3125>, 2.25",
        "circle: <0.0, 0.4375>, 2.75",
        "circle: <0.0, 0.75>, 4.0",
        "circle: <0.0, 0.625>, 3.5",
        "circle: <0.0, 0.5625>, 3.25",
        "circle: <0.0, 0.6875>, 3.75",
        "circle: <0.0, 0.875>, 4.5",
        "circle: <0.0, 0.8125>, 4.25",
        "circle: <0.0, 0.9375>, 4.75"])
      
    }
    
    func testDrawsStampedLinear() {
      func stamper(point: Point, renderer: Renderer) {
        renderer.circle(point, radius: point.weight)
      }
      
      renderer.stampedLinear([
        Point(x: 0, y: 0, weight: 1),
        Point(x: 0, y: 0.5, weight: 2),
        Point(x: 0, y: 1, weight: 1),
        ], stamper: stamper, minimumGap: 0.1)
      
      XCTAssertEqual(renderer.currentImage, [
        "circle: <0.0, 0.0>, 1.0",
        "circle: <0.0, 0.25>, 1.5",
        "circle: <0.0, 0.125>, 1.25",
        "circle: <0.0, 0.0625>, 1.125",
        "circle: <0.0, 0.1875>, 1.375",
        "circle: <0.0, 0.375>, 1.75",
        "circle: <0.0, 0.3125>, 1.625",
        "circle: <0.0, 0.4375>, 1.875",
        "circle: <0.0, 0.5>, 2.0",
        "circle: <0.0, 0.75>, 1.5",
        "circle: <0.0, 0.625>, 1.75",
        "circle: <0.0, 0.5625>, 1.875",
        "circle: <0.0, 0.6875>, 1.625",
        "circle: <0.0, 0.875>, 1.25",
        "circle: <0.0, 0.8125>, 1.375",
        "circle: <0.0, 0.9375>, 1.125"])
    }

    func testBezierPoint() {
      let p = renderer.bezierPoint((
        a: Point(x: 0, y: 0),
        cp1: Point(x: -1, y: 0),
        cp2: Point(x: 1, y: 1),
        b: Point(x: 0, y: 1)), t: 0.5)

      XCTAssertEqual(p, Point(x: 0, y: 0.5))
    }


    func testDrawsStampedBezier() {
      func stamper(point: Point, renderer: Renderer) {
        renderer.circle(point, radius: point.weight)
      }

      renderer.stampedBezier((
        a: Point(x: 0, y: 0, weight: 1),
        cp1: Point(x: -1, y: 0),
        cp2: Point(x: 1, y: 1),
        b: Point(x: 0, y: 1, weight: 4)),
        stamper: stamper, minimumGap: 0.1)

      XCTAssertEqual(renderer.currentImage, [
        "circle: <0.0, 0.0>, 1.0",
        "circle: <-0.28125, 0.15625>, 1.75",
        "circle: <0.0, 0.5>, 2.5",
        "circle: <0.28125, 0.84375>, 3.25"])
    }
}  
  