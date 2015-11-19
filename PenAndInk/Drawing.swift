// An image is a series of undo frames -- but it is drawn as just it's most recent frame.

class Drawing<I:Image>: ImageDrawable {
  typealias ImageType = I
  typealias Frame = UndoFrame<ImageType>

  var frames: [Frame] = []
  var snapshot: ImageType?
  let strokesPerFrame = 10

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    // renderer.reset
    if let lastFrame = frames.last {
      lastFrame.draw(renderer)
    }
    snapshot = renderer.currentImage
  }

  func addStroke(stroke: Stroke) {
    lastOpenFrame().addStroke(stroke)
    snapshot = nil
  }

  private func newFrame() -> Frame {
    let frame = snapshot == nil ? Frame() : Frame(initialImage: snapshot!)
    frames.append(frame)
    return frame
  }

  private func lastOpenFrame() -> Frame {
    // If this will be the first frame
    if frames.last == nil {
      return newFrame()

      // If the current frame is full and the snapshot is up to date
    } else if snapshot != nil && frames.last!.strokes.count >= strokesPerFrame {
      return newFrame()

      // Otherwise, keep filling the current frame
    } else {
      return frames.last!
    }
  }
}

