class Snapshot<I> : ImageDrawable {
  typealias ImageType = I

  let snapshot: ImageType
  let strokeIndex: Int

  init(snapshot: ImageType, strokeIndex: Int) {
    self.snapshot = snapshot
    self.strokeIndex = strokeIndex
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    renderer.image(self.snapshot)
  }
}

struct SnapshotIndex {
  let stroke: Int
  let snapshot: Int
}
