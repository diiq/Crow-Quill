// An image is a series of frames -- but it's drawn as just it's most recent frame.

class Drawing<I:Image> : ImageDrawable {
  typealias ImageType = I

  var frames: [UndoFrame<ImageType>] = []
  var snapshot: ImageType?
  let strokesPerFrame = 10

  func draw<R:ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    if let lastFrame = frames.last {
      lastFrame.draw(renderer)
    }
  }

  func newFrame() {

  }

  func addStroke(stroke: Stroke) {
    guard let lastFrame = frames.last else {
      frames.append(UndoFrame<ImageType>())
      return
    }

    if lastFrame.strokes.count < strokesPerFrame {
      lastFrame.addStroke(stroke)
    } else {
      frames.append(UndoFrame<ImageType>())
    }
  }
}

