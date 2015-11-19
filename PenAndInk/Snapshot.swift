class Snapshot<I> : ImageDrawable {
  typealias ImageType = I

  let snapshot: ImageType
  let index: Int

  init(snapshot: ImageType, index: Int) {
    self.snapshot = snapshot
    self.index = index
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    renderer.image(self.snapshot)
  }
}