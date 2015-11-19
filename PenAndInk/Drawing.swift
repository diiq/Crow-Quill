// A drawing is a collection of strokes -- with intermediate snapshots to optimize rendering times.

class Drawing<I>: ImageDrawable {
  typealias ImageType = I
  typealias Snap = Snapshot<ImageType>

  var snapshots: [Snap] = []
  var currentImage: ImageType?
  var strokes: [Stroke] = []
  let strokesPerSnapshot = 10
  var currentStrokeIndex = -1
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
    currentStrokeIndex += 1
    if strokesSinceSnapshot >= strokesPerSnapshot {
      addSnapshot()
    }
    currentImage = nil
  }

  private func addSnapshot() {
    guard let img = currentImage else { return }
    snapshots.append(Snap(snapshot: img, strokeIndex: currentStrokeIndex))
    currentSnapshotIndex += 1
  }
}

/*

Criteria to satisfy:

- undo one stroke very quickly                         √
- undo many-many strokes quickly                       √
- redo strokes quickly                                 ?
- fork from a small number of undos quickly            ?
- fork from a large number of undos with confirmation  ?
- replay whole drawing from the beginning easily       √
- undo history preserved between saves                 √

*/