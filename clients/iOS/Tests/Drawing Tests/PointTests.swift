import XCTest
@testable import Crow_Quill

class PointTests: XCTestCase {
  func testLength() {
    let point = Point(x: 4, y: 3)
    XCTAssertEqual(point.length(), 5.0)
  }
  
  func testUnit() {
    let point = Point(x: 4, y: 3)
    let unit = Point(x: 0.8, y: 0.6)
    XCTAssertEqual(point.unit(), unit)
  }

  func testPerpendicular() {
    let point = Point(x: 4, y: 3)
    let perpendicular = Point(x: -0.6, y: 0.8)
    XCTAssertEqual(point.perpendicular(), perpendicular)
  }

  func testDot() {
    let point = Point(x: 4, y: 3)
    let point2 = Point(x: 1, y: 2)
    XCTAssertEqual(point.dot(point2), 10.0)
  }

  func testDownward() {
    var point = Point(x: 10, y: -20)
    var expectedResult = Point(x: -10, y: 20)
    XCTAssertEqual(point.downward(), expectedResult)
    
    point = Point(x: 10, y: 20)
    expectedResult = Point(x: 10, y: 20)
    XCTAssertEqual(point.downward(), expectedResult)
    
    point = Point(x: -10, y: -20)
    expectedResult = Point(x: 10, y: 20)
    XCTAssertEqual(point.downward(), expectedResult)
  }
  
  //func *(left: Point, right: Double) -> Point {
  //  return Point(x: left.x * right, y: left.y * right, weight: -1)
  //}
  //
  //func *(left: Double, right: Point) -> Point {
  //  return right * left
  //}
  //
  //func /(left: Point, right: Double) -> Point {
  //  return Point(x: left.x / right, y: left.y / right, weight: -1)
  //}
  //
  //func +(left: Point, right: Point) -> Point {
  //  return Point(x: left.x + right.x, y: left.y + right.y, weight: -1)
  //}
  //
  //func -(left: Point, right: Point) -> Point {
  //  return Point(x: left.x - right.x, y: left.y - right.y, weight: -1)
  //}
}
