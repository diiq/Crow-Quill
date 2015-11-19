// An image is a series of undo frames -- but it is drawn as just it's most recent frame.

class Drawing<I>: ImageDrawable {
  typealias ImageType = I
  typealias Snap = Snapshot<ImageType>

  var snapshots: [Snap] = []
  var currentImage: ImageType?
  var strokes: [Stroke] = []
  let strokesPerFrame = 10

  var strokesSinceSnapshot: Int {
    return strokes.count - lastSnapshotIndex
  }

  var lastSnapshotIndex: Int {
    return (snapshots.last?.index ?? 0)
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // Draw the last snapshot:
    if snapshots.last != nil {
      snapshots.last!.draw(renderer)
    }

    // Draw every stroke since the last snapshot
    for i in lastSnapshotIndex..<strokes.count {
      strokes[i].draw(renderer)
    }

    currentImage = renderer.currentImage
  }

  func addStroke(stroke: Stroke) {
    strokes.append(stroke)
    if strokesSinceSnapshot >= strokesPerFrame {
      addSnapshot()
    }
    currentImage = nil
  }

  private func addSnapshot() {
    guard let img = currentImage else { return }
    snapshots.append(Snap(snapshot: img, index: snapshots.count))
  }
}

/*

I think maybe get rid of UndoFrame and instead make a snapshot struct which stores an image and a pointer into the array of strokes. 

Then we can abstract the array of strokes when necessary.

drawSince, maybe

*/