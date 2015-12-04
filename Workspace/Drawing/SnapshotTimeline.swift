/**
 A SnapshotTimeline is a timeline of snapshots of the drawing.

 We don't take snapshots *every* stroke -- but the occasional snapshots need to
 behave correctly when strokes are undone, redone, or changed; and we need to
 be able to easily grab the nearest snapshot for any given moment in the full
 timeline.

 */

class SnapshotTimeline<ImageType> {
  // TODO: This may want to become a linked list -- better memory usage if I
  // could prune old snapshots. But the interface can remain the same, so I'll
  // keep it as-is for now.
  var snapshots = Timeline<Snapshot<ImageType>>()
  let snapshotEveryNEvents = 10

  func currentSnapshot() -> Snapshot<ImageType>? {
    return snapshots.latest()
  }

  /// Winds the timeline to the appropriate snapshot, given the index of an
  /// event in the full timeline.
  func undoTo(action: Int) {
    var latest = snapshots.latest()
    while latest != nil && latest!.eventIndex > action {
      snapshots.undo()
      latest = snapshots.latest()
    }
  }

  /// Winds the timeline to the appropriate snapshot, given the index of an
  /// event in the full timeline.
  func redoTo(action: Int) {
    var latest = snapshots.latest()
    while snapshots.canRedo() && (latest == nil || latest!.eventIndex <= action) {
      snapshots.redo()
      latest = snapshots.latest()
    }
    snapshots.undo()
  }

  /**
   Call modified() whenever a timeline event occurs -- whether its time to take
   a snapshot or not.

   It ensures that, if the event occurs after a series of undos, the
   now-obsolete snapshots are not accidentally reused.
   */
  func modified() {
    snapshots.modified()
  }

  func add(snapshot: ImageType, index: Int) {
    snapshots.add(
      Snapshot<ImageType>(snapshot: snapshot, eventIndex: index)
    )
  }
}