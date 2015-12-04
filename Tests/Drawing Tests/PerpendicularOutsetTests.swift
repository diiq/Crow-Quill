import XCTest
@testable import Crow_Quill

class ForwardPerpendicularOutsetTests: XCTestCase {
  lazy var fwdTransformation = ForwardPerpendicularOutset()
  lazy var bwdTransformation = BackwardPerpendicularOutset()
  lazy var horizontalPoints : [Point] = {
    return (1...5).map {
      return Point(x: 10.0 * Double($0), y: 50.0, weight: 2*Double($0))
    }
  }()

  lazy var verticalPoints : [Point] = {
    return (1...5).map {
      return Point(x: 50.0, y: 10.0 * Double($0), weight: 2*Double($0))
    }
  }()

  func testForwardHorizontal() {
    let actualPoints = fwdTransformation.apply(horizontalPoints)
    let expectedPoints = [
      Point(x: 10.0, y: 51, weight: -1),
      Point(x: 20.0, y: 52, weight: -1),
      Point(x: 30.0, y: 53, weight: -1),
      Point(x: 40.0, y: 54, weight: -1),
      Point(x: 50.0, y: 55, weight: -1)]
    XCTAssertEqual(actualPoints, expectedPoints)
  }

  func testBackwardHorizontal() {
    let actualPoints = bwdTransformation.apply(horizontalPoints)
    let expectedPoints = [
      Point(x: 10.0, y: 49, weight: -1),
      Point(x: 20.0, y: 48, weight: -1),
      Point(x: 30.0, y: 47, weight: -1),
      Point(x: 40.0, y: 46, weight: -1),
      Point(x: 50.0, y: 45, weight: -1)]
    XCTAssertEqual(actualPoints, expectedPoints)
  }

  func testForwardVertical() {
    let actualPoints = fwdTransformation.apply(verticalPoints)
    let expectedPoints = [
      Point(x: 49, y: 10, weight: -1),
      Point(x: 48, y: 20, weight: -1),
      Point(x: 47, y: 30, weight: -1),
      Point(x: 46, y: 40, weight: -1),
      Point(x: 45, y: 50, weight: -1)]
    XCTAssertEqual(actualPoints, expectedPoints)
  }

  func testBackwardVertical() {
    let actualPoints = bwdTransformation.apply(verticalPoints)
    let expectedPoints = [
      Point(x: 51, y: 10, weight: -1),
      Point(x: 52, y: 20, weight: -1),
      Point(x: 53, y: 30, weight: -1),
      Point(x: 54, y: 40, weight: -1),
      Point(x: 55, y: 50, weight: -1)]
    XCTAssertEqual(actualPoints, expectedPoints)
  }
}
