class SnapshotCollection<ImageType> {
  var snapshots = UndoArray<Snapshot<ImageType>>()
  
  func currentSnapshot() -> Snapshot<ImageType>? {
    return snapshots.latestAction()
  }
  
  func undoTo(action: Int) {
    var latest = snapshots.latestAction()
    while latest != nil && latest!.actionIndex > action {
      snapshots.undo()
      latest = snapshots.latestAction()
    }
  }
  
  func redoTo(action: Int) {
    var latest = snapshots.latestAction()
    while snapshots.canRedo() && (latest == nil || latest!.actionIndex <= action) {
      snapshots.redo()
      latest = snapshots.latestAction()
    }
    snapshots.undo()
  }
  
  func modified() {
    snapshots.modified()
  }
  
  func add(snapshot: ImageType, actionIndex: Int) {
    snapshots.add(
      Snapshot<ImageType>(snapshot: snapshot, actionIndex: actionIndex)
    )
  }
}