import XCTest
@testable import Crow_Quill

class GuideTests: XCTestCase {
  lazy var guide = Guide()
  lazy var renderer = TestRenderer()

  func testDraw() {
    guide.draw(renderer)
    XCTAssertEqual(renderer.currentImage, [

    ], "Draws the guide")
  }


}