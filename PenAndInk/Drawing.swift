// An image is a series of undo frames -- but it is drawn as just it's most recent frame.

class Drawing<I:Image>: ImageDrawable {
  typealias ImageType = I
  typealias Frame = UndoFrame<ImageType>

  var frames: [Frame] = []
  var snapshot: ImageType?
  let strokesPerFrame: Int

  init(strokesPerFrame: Int) {
    self.strokesPerFrame = strokesPerFrame
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    if let lastFrame = frames.last {
      lastFrame.draw(renderer)
    }
  }

  func newFrame() -> Frame {
    let frame = (snapshot == nil) ? Frame() : Frame(initialImage: snapshot!)
    frames.append(frame)
    return frame
  }

  func lastOpenFrame() -> Frame {
    if frames.last == nil || frames.last!.strokes.count >= strokesPerFrame {
      return newFrame()
    } else {
      return frames.last!
    }
  }

  func addStroke(stroke: Stroke) {
    lastOpenFrame().addStroke(stroke)
  }
}

