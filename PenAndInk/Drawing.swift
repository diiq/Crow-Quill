// A drawing is a collection of strokes -- with intermediate snapshots to optimize rendering times.

class Drawing<I>: ImageDrawable {
  typealias ImageType = I
  var strokes = UndoArray<Stroke>()
  var snapshots = SnapshotCollection<ImageType>()
  
  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw every stroke since the last snapshot
    if snapshots.currentSnapshot() != nil {
      snapshots.currentSnapshot()?.draw(renderer)
    }
    strokes.actions(since: snapshots.currentSnapshot()?.actionIndex ?? 0).forEach {
      $0.draw(renderer)
    }
    
    // Preserve the current rendered state of the drawing
    if shouldSnapshot(){
      snapshots.add(
        renderer.currentImage,
        actionIndex: strokes.currentIndex)
    }
  }

  private func shouldSnapshot() -> Bool {
    return strokes.currentIndex % 10 == 0
  }
  
  func addStroke(stroke: Stroke) {
    strokes.add(stroke)
    snapshots.modified()
  }

  func undoStroke() {
    strokes.undo()
    snapshots.undoTo(strokes.currentIndex)
  }

  func redoStroke() {
    strokes.redo()
    snapshots.redoTo(strokes.currentIndex)
  }
}

/*

Criteria to satisfy:

- undo one stroke very quickly                         √
- undo many-many strokes quickly                       √
- redo strokes quickly                                 √
- fork from a small number of undos quickly            √
- fork from a large number of undos with confirmation  ?
- replay whole drawing from the beginning easily       √
- undo history preserved between saves                 ?
- fairly constant memory usage (serializable to disk?) X

*/