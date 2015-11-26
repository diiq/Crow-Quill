import XCTest
@testable import Crow_Quill

class TimelineTests: XCTestCase {
  var timeline = Timeline<Int>()

  func testAddInitialElement() {
    timeline.add(1)
    let events = timeline.events()
    XCTAssertEqual(events.count, 1, "add element adds an element")
  }

  func testAddSecondElement() {
    timeline.add(1)
    timeline.add(2)
    let events = timeline.events()
    XCTAssertEqual(events.count, 2, "adding an element adds an element")
    XCTAssertEqual(events[0], 1, "adding an element adds an element in order")
    XCTAssertEqual(events[1], 2, "adding an element adds an element in order")
  }

  func testCanUndo() {
    XCTAssertEqual(timeline.canUndo(), false, "can't undo if there are no events")
    timeline.add(1)
    XCTAssertEqual(timeline.canUndo(), true, "can undo if there are events")
    timeline.add(2)
    XCTAssertEqual(timeline.canUndo(), true, "can undo if there are events")
    timeline.undo()
    XCTAssertEqual(timeline.canUndo(), true, "can undo if we've undo-ed, but there are still events")
    timeline.undo()
    XCTAssertEqual(timeline.canUndo(), false, "can't undo if we've undo-ed all the way")
  }

  func testCanRedo() {
    XCTAssertEqual(timeline.canRedo(), false, "can't redo if there are no events")
    timeline.add(1)
    XCTAssertEqual(timeline.canRedo(), false, "can't redo if there are no future events")
    timeline.add(2)
    XCTAssertEqual(timeline.canRedo(), false, "can't redo if there are no future events")
    timeline.undo()
    XCTAssertEqual(timeline.canRedo(), true, "can redo if we've undo-ed")
    timeline.redo()
    XCTAssertEqual(timeline.canRedo(), false, "can't redo if we've redo-ed all the way")
  }

  func testUndo() {
    timeline.add(1)
    timeline.add(2)
    var events = timeline.events()
    XCTAssertEqual(events.count, 2)

    timeline.undo()
    events = timeline.events()
    XCTAssertEqual(events.count, 1, "undoing once removes an action")
    XCTAssertEqual(events[0], 1, "undoing once leaves previous events")

    timeline.undo()
    events = timeline.events()
    XCTAssertEqual(events.count, 0, "undoing all the way leaves no events")
  }

  func testRedo() {
    timeline.add(1)
    timeline.add(2)
    timeline.undo()
    timeline.undo()
    var events = timeline.events()
    XCTAssertEqual(events.count, 0)

    timeline.redo()
    events = timeline.events()
    XCTAssertEqual(events.count, 1, "redoing once replaces an action")
    XCTAssertEqual(events[0], 1, "redoing replaces events oldest-first")

    timeline.redo()
    events = timeline.events()
    XCTAssertEqual(events.count, 2, "redoing all the way restores all the events")
  }

  func testEventsSince() {
    timeline.add(1)
    timeline.add(2)
    var events = timeline.events(since: 1)
    XCTAssertEqual(events.count, 1)
    XCTAssertEqual(events[events.startIndex], 2, "events:since returns events after the given index")
  }
}
