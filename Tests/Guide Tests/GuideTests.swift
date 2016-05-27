import XCTest
@testable import Crow_Quill

class GuideTests: XCTestCase {
  lazy var guide = RulerGuide()
  lazy var renderer = TestRenderer()

  func testDraw() {
    guide.draw(renderer)
    XCTAssertEqual(renderer.currentImage, [
      "color",
      "move: <10055.7192889562, 1893.30956924518>",
      "line: <10055.7192889562, 1893.30956924518>, <-9672.15918768671, -1394.67017686197>",
      "line: <-9672.15918768671, -1394.67017686197>, <-9655.71928895617, -1493.30956924518>",
      "line: <-9655.71928895617, -1493.30956924518>, <10072.1591876867, 1794.67017686197>",
      "line: <10072.1591876867, 1794.67017686197>, <10055.7192889562, 1893.30956924518>",
      "stroke",
      
      "color",
      "move: <10063.9392383214, 1843.98987305357>",
      "line: <10063.9392383214, 1843.98987305357>, <-9663.93923832144, -1443.98987305357>",
      "stroke",
      
      "color",
      "circle: <200.0, 200.0>, 6.4",
      "fill",
      
      "color",
      "circle: <800.0, 300.0>, 6.4",
      "fill"
      ], "Draws the guide and its handles")
  }
}