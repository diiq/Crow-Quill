struct Snapshot<I> : ImageDrawable {
  typealias ImageType = I

  let snapshot: ImageType
  let eventIndex: Int

  func draw<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType {
    renderer.image(self.snapshot)
  }
}
