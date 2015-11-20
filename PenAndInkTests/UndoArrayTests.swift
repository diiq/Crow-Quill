import XCTest
@testable import PenAndInk

class UndoArrayTests: XCTestCase {
  var undoArray = UndoArray<Int>()
  
  func testAddInitialElement() {
    undoArray.add(1)
    let actions = undoArray.actions()
    XCTAssertEqual(actions.count, 1, "add element adds an element")
  }
  
  func testAddSecondElement() {
    undoArray.add(1)
    undoArray.add(2)
    let actions = undoArray.actions()
    XCTAssertEqual(actions.count, 2, "adding an element adds an element")
    XCTAssertEqual(actions[0], 1, "adding an element adds an element in order")
    XCTAssertEqual(actions[1], 2, "adding an element adds an element in order")
  }
  
  func testCanUndo() {
    XCTAssertEqual(undoArray.canUndo(), false, "can't undo if there are no actions")
    undoArray.add(1)
    XCTAssertEqual(undoArray.canUndo(), true, "can undo if there are actions")
    undoArray.add(2)
    XCTAssertEqual(undoArray.canUndo(), true, "can undo if there are actions")
    undoArray.undo()
    XCTAssertEqual(undoArray.canUndo(), true, "can undo if we've undo-ed, but there are still actions")
    undoArray.undo()
    XCTAssertEqual(undoArray.canUndo(), false, "can't undo if we've undo-ed all the way")
  }
  
  func testCanRedo() {
    XCTAssertEqual(undoArray.canRedo(), false, "can't redo if there are no actions")
    undoArray.add(1)
    XCTAssertEqual(undoArray.canRedo(), false, "can't redo if there are no future actions")
    undoArray.add(2)
    XCTAssertEqual(undoArray.canRedo(), false, "can't redo if there are no future actions")
    undoArray.undo()
    XCTAssertEqual(undoArray.canRedo(), true, "can redo if we've undo-ed")
    undoArray.redo()
    XCTAssertEqual(undoArray.canRedo(), false, "can't redo if we've redo-ed all the way")
  }
  
  func testUndo() {
    undoArray.add(1)
    undoArray.add(2)
    var actions = undoArray.actions()
    XCTAssertEqual(actions.count, 2)
    
    undoArray.undo()
    actions = undoArray.actions()
    XCTAssertEqual(actions.count, 1, "undoing once removes an action")
    XCTAssertEqual(actions[0], 1, "undoing once leaves previous actions")
    
    undoArray.undo()
    actions = undoArray.actions()
    XCTAssertEqual(actions.count, 0, "undoing all the way leaves no actions")
  }
  
  func testRedo() {
    undoArray.add(1)
    undoArray.add(2)
    undoArray.undo()
    undoArray.undo()
    var actions = undoArray.actions()
    XCTAssertEqual(actions.count, 0)
    
    undoArray.redo()
    actions = undoArray.actions()
    XCTAssertEqual(actions.count, 1, "redoing once replaces an action")
    XCTAssertEqual(actions[0], 1, "redoing replaces actions oldest-first")
    
    undoArray.redo()
    actions = undoArray.actions()
    XCTAssertEqual(actions.count, 2, "redoing all the way restores all the actions")
  }
  
  func testActionsSince() {
    undoArray.add(1)
    undoArray.add(2)
    var actions = undoArray.actions(since: 1)
    XCTAssertEqual(actions.count, 1)
    XCTAssertEqual(actions[actions.startIndex], 2, "actions:since returns actions after the given index")
  }
}
