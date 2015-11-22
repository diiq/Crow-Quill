import XCTest
@testable import PenAndInk

class TestRendererTests: XCTestCase {
  let renderer = TestRenderer()

  func testDrawsAStraightLine() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    renderer.line(
      StrokePoint(x: 10, y: 50, weight: 1),
      StrokePoint(x: 20, y: 30, weight: 1))

    XCTAssertEqual(renderer.currentImage, ["line: <10.0, 50.0>, <20.0, 30.0>"],
      "Calling line adds a single string")
  }

  func testDrawsCentripitalCatmullRom() {
    let points = [
      StrokePoint(x: 10, y: 50, weight: 1),
      StrokePoint(x: 13, y: 20, weight: 1),
      StrokePoint(x: 20, y: 5, weight: 1),
      StrokePoint(x: 40, y: 25, weight: 1),
      StrokePoint(x: 30, y: 30, weight: 1),
      StrokePoint(x: 40, y: 22, weight: 1),
      StrokePoint(x: 50, y: 11, weight: 1)
    ]

    renderer.catmullRom(points)
    print(renderer.currentImage)
    XCTAssertEqual(renderer.currentImage, [
      "bezier: <10.0, 50.0>, [<10.0, 50.0>, <10.7655948217843, 28.1320530324688>], <13.0, 20.0>",
      "bezier: <13.0, 20.0>, [<14.655612127817, 13.9744475371484>, <16.4674918456904, 5.62233954523958>], <20.0, 5.0>",
      "bezier: <20.0, 5.0>, [<24.6176182841822, 4.18649120184987>, <40.6817392384564, 20.7989335208>], <40.0, 25.0>",
      "bezier: <40.0, 25.0>, [<39.5713791456192, 27.6412807156333>, <30.2187834822991, 30.3419387419195>], <30.0, 30.0>",
      "bezier: <30.0, 30.0>, [<29.7658479365523, 29.6340415594826>, <36.7819717026072, 25.0211962453936>], <40.0, 22.0>",
      "bezier: <40.0, 22.0>, [<43.4671846009055, 18.7448872010141>, <50.0, 11.0>], <50.0, 11.0>"],
      "Calling line adds a single string")
  }
}

