// A drawing is a collection of strokes -- with intermediate snapshots to optimize rendering times.

class Drawing<I>: ImageDrawable {
  typealias ImageType = I
  typealias Snap = Snapshot<ImageType>

  var snapshots: [Snap] = []
  var currentImage: ImageType?
  var strokes: [Stroke] = []
  let strokesPerSnapshot = 20
  var currentStrokeIndex = 0
  var currentSnapshotIndex = -1
  
  var currentSnapshot: Snap? {
    if snapshots.count == 0 {
      return nil
    }
    return snapshots[currentSnapshotIndex]
  }
  
  var strokesSinceSnapshot: Int {
    return currentStrokeIndex - (currentSnapshot?.strokeIndex ?? 0)
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw the last snapshot:
    if snapshots.count > 0 {
      snapshots[currentSnapshotIndex].draw(renderer)
    }

    // Draw every stroke since the last snapshot
    for i in (currentSnapshot?.strokeIndex ?? 0)..<currentStrokeIndex {
      strokes[i].draw(renderer)
    }

    // Preserve the current rendered state of the drawing
    currentImage = renderer.currentImage
  }

  func addStroke(stroke: Stroke) {
    strokes.append(stroke)
    if strokesSinceSnapshot >= strokesPerSnapshot {
      addSnapshot()
    }
    currentStrokeIndex += 1
    currentImage = nil
  }

  func undoStroke() {
    if currentStrokeIndex > 0 {
      currentStrokeIndex -= 1

      // DANGER REDO THIS -- handle when no strokes, handle when either index is 0.
      if currentSnapshot != nil && currentStrokeIndex < currentSnapshot!.strokeIndex && currentSnapshotIndex > 0 {
        currentSnapshotIndex -= 1
      }
    }
  }

  func redoStroke() {
    if currentStrokeIndex < strokes.count {
      currentStrokeIndex += 1
      // DANGER REDO THIS
      if currentSnapshot != nil && currentSnapshotIndex + 1 < snapshots.count && currentStrokeIndex > snapshots[currentSnapshotIndex].strokeIndex {
        currentSnapshotIndex += 1
      }
    }
  }

  private func addSnapshot() {
    guard let img = currentImage else { return }
    snapshots.append(Snap(snapshot: img, strokeIndex: currentStrokeIndex))
    currentSnapshotIndex += 1
  }
}

/*

Criteria to satisfy:

Drawing:
  draw (draw from given index to current)
  undo (devances the index if possible)
  redo (advances the index)
  addStroke (drops any future strokes; adds stroke)


Let's add a struct for a undoable array -- it's got a 'current' pointer, a 'max' pointer, it has append, undo, and redo. It can, eventually, support serialization to disk.

Let's separate the drawing protobol from the snapshotting stuff.


- undo one stroke very quickly                         √
- undo many-many strokes quickly                       ?
- redo strokes quickly                                 √
- fork from a small number of undos quickly            ?
- fork from a large number of undos with confirmation  ?
- replay whole drawing from the beginning easily       √
- undo history preserved between saves                 √
- fairly constant memory usage (serializable to disk?) X

*/