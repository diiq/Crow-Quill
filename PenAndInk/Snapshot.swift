struct Snapshot<I> : ImageDrawable {
  typealias ImageType = I
  
  let snapshot: ImageType
  let actionIndex: Int
  
  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    renderer.image(self.snapshot)
  }
}