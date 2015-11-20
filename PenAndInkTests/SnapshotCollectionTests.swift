import XCTest
@testable import PenAndInk

class SnapshotCollectionTests: XCTestCase {
  var snapshots = SnapshotCollection<String>()

  func testAddSnapshot() {
    snapshots.add("first", actionIndex: 10)
    XCTAssertEqual(
      snapshots.currentSnapshot()!.snapshot,
      "first",
      "adding a snapshot makes it the current snapshot")
  }
  
  func testUndoTo() {
    snapshots.add("no", actionIndex: 10)
    snapshots.add("yes", actionIndex: 20)
    snapshots.add("no", actionIndex: 30)
    snapshots.undoTo(25)
    XCTAssertEqual(
      snapshots.currentSnapshot()!.snapshot,
      "yes",
      "undoing finds the 'price is right' snapshot -- the closest without going over")
  }
  
  func testUndoToExact() {
    snapshots.add("no", actionIndex: 10)
    snapshots.add("yes", actionIndex: 20)
    snapshots.add("no", actionIndex: 30)
    snapshots.undoTo(20)
    XCTAssertEqual(
      snapshots.currentSnapshot()!.snapshot,
      "yes",
      "undoing finds the perfect snapshot, when one exists")
  }

  func testUndoAllTheWay() {
    snapshots.add("no", actionIndex: 10)
    snapshots.add("yes", actionIndex: 20)
    snapshots.add("no", actionIndex: 30)
    snapshots.undoTo(5)
    XCTAssert(
      snapshots.currentSnapshot() == nil,
      "undoing all the way undoes ALL the way")
  }
  
  func testRedoTo() {
    snapshots.add("no", actionIndex: 10)
    snapshots.add("yes", actionIndex: 20)
    snapshots.add("no", actionIndex: 30)
    snapshots.undoTo(5)
    snapshots.redoTo(25)
    XCTAssertEqual(
      snapshots.currentSnapshot()!.snapshot,
      "yes",
      "redoing finds the 'price is right' snapshot -- the closest without going over")
  }
}