/**
 A drawing is a timeline of strokes that can be made, undone, and redone.
 Drawings preserve intermediate snapshots to optimize rendering times --
 it's a time/space tradeoff.

 Criteria I'm trying to satisfy:

 - [√] undo one stroke very quickly
 - [√] undo many-many strokes quickly
 - [√] redo strokes quickly
 - [√] fork from a small number of undos quickly
 - [ ] fork from a large number of undos with confirmation
 - [√] replay whole drawing from the beginning easily
 - [ ] undo history preserved between saves
 - [ ] fairly constant memory usage

 */

class Drawing<Image>: ImageDrawable {
  typealias ImageType = Image
  private var strokes = Timeline<Stroke>()
  private var snapshots = SnapshotTimeline<ImageType>()
  var pointsPerSnapshot = 10000

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw the most recent snapshot
    snapshots.currentSnapshot()?.draw(renderer)

    // Draw every stroke since the last snapshot
    strokes.events(since: mostRecentSnapshotIndex()).forEach {
      $0.draw(renderer)
    }

    // Preserve the current rendered state of the drawing
    // is renderer.currentImage expensive enough I should skip it when
    // I'm not actually snapshotting?
    if shouldSnapshot() {
      snapshots.add(renderer.currentImage, index: strokes.currentIndex)
    }
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

  private func mostRecentSnapshotIndex() -> Int {
    return snapshots.currentSnapshot()?.eventIndex ?? 0
  }

  private func shouldSnapshot() -> Bool {
    return pointsSinceSnapshot() > pointsPerSnapshot
  }

  private func pointsSinceSnapshot() -> Int {
    let liveStrokes = strokes.events(since: mostRecentSnapshotIndex())
    let counts = liveStrokes.map { return $0.points.count }
    return counts.reduce(0, combine: +)
  }
}

