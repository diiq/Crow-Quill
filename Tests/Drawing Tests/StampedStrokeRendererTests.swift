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
        "circle: <0.0, 0.5>, 2.5",
        "circle: <-0.28125, 0.15625>, 1.75",
        "circle: <-0.24609375, 0.04296875>, 1.375",
        "circle: <-0.15380859375, 0.01123046875>, 1.1875",
        "circle: <-0.08514404296875, 0.00286865234375>, 1.09375",
        "circle: <-0.28564453125, 0.09228515625>, 1.5625",
        "circle: <-0.17578125, 0.31640625>, 2.125",
        "circle: <-0.24169921875, 0.23193359375>, 1.9375",
        "circle: <-0.21148681640625, 0.27325439453125>, 2.03125",
        "circle: <-0.09228515625, 0.40673828125>, 2.3125",
        "circle: <-0.13568115234375, 0.36102294921875>, 2.21875",
        "circle: <-0.04669189453125, 0.45318603515625>, 2.40625",
        "circle: <0.28125, 0.84375>, 3.25",
        "circle: <0.17578125, 0.68359375>, 2.875",
        "circle: <0.09228515625, 0.59326171875>, 2.6875",
        "circle: <0.04669189453125, 0.54681396484375>, 2.59375",
        "circle: <0.13568115234375, 0.63897705078125>, 2.78125",
        "circle: <0.24169921875, 0.76806640625>, 3.0625",
        "circle: <0.21148681640625, 0.72674560546875>, 2.96875",
        "circle: <0.24609375, 0.95703125>, 3.625",
        "circle: <0.28564453125, 0.90771484375>, 3.4375",
        "circle: <0.15380859375, 0.98876953125>, 3.8125",
        "circle: <0.08514404296875, 0.99713134765625>, 3.90625"])
    }
}