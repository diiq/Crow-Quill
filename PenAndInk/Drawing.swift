// A drawing is a collection of strokes -- with intermediate snapshots to optimize rendering times.

class Drawing<I>: ImageDrawable {
  typealias ImageType = I
  typealias Snap = Snapshot<ImageType>

  var currentImage: ImageType?
  var strokes = UndoArray<Stroke>()
  var lastDrawnStroke: Int = 0
  
  func fastdraw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw every stroke since the last snapshot
    strokes.actions(since: lastDrawnStroke).forEach {
      $0.draw(renderer)
    }

    // Preserve the current rendered state of the drawing
    currentImage = renderer.currentImage
    lastDrawnStroke = strokes.currentIndex
  }
  
  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw every stroke since the last snapshot
    strokes.actions().forEach {
      $0.draw(renderer)
    }
    
    // Preserve the current rendered state of the drawing
    currentImage = renderer.currentImage
    lastDrawnStroke = strokes.currentIndex
  }

  func addStroke(stroke: Stroke) {
    strokes.add(stroke)
  }

  func undoStroke() {
    strokes.undo()
  }

  func redoStroke() {
    strokes.redo()
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