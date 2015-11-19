

class UndoFrame<I:Image> : ImageDrawable {
  typealias ImageType = I

  let initialImage: ImageType
  var strokes: [Stroke] = []

  init(initialImage: ImageType) {
    self.initialImage = initialImage
  }

  init() {
    self.initialImage = ImageType()
  }

  func draw<R:ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    renderer.image(self.initialImage)
    strokes.forEach { $0.draw(renderer) }
  }

  func addStroke(stroke: Stroke) {
    self.strokes.append(stroke)
  }
}