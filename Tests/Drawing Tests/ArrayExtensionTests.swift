import XCTest
@testable import Crow_Quill

class ArrayExtensionTests: XCTestCase {
  func testSlidingWindow() {
    let arr = [1, 2, 3, 4, 5]
    let result: [Int] = arr.slidingWindow { focus, before, after in
      return focus
    }
    let expected = [1, 2, 3, 4, 5]
    XCTAssertEqual(result, expected)
  }

  func testSlidingWindowBefore() {
    let arr = [1, 2, 3, 4, 5]
    let result: [Int] = arr.slidingWindow { focus, before, after in
      guard before != nil else { return nil }
      return focus
    }
    let expected = [2, 3, 4, 5]
    XCTAssertEqual(result, expected)
  }

  func testSlidingWindowAfter() {
    let arr = [1, 2, 3, 4, 5]
    let result: [Int] = arr.slidingWindow { focus, before, after in
      guard after != nil else { return nil }
      return focus
    }
    let expected = [1, 2, 3, 4]
    XCTAssertEqual(result, expected)
  }

  func testSlidingWindowShort() {
    let arr = [1]
    let result: [Int] = arr.slidingWindow { focus, before, after in
      return focus
    }
    let expected = [1]
    XCTAssertEqual(result, expected)
  }

  func testSafeAccess() {
    let arr = [0, 1, 2, 3, 4, 5]
    XCTAssert(arr[safe: 3] == 3)
    XCTAssert(arr[safe: 6] == nil)
    XCTAssert(arr[safe: -1] == nil)
  }

}
