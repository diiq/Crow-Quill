/**
 A drawable is anything that has a draw method, which takes a renderer and
 produces an image.
 */
protocol Drawable {
  func draw(_ renderer: Renderer)
}

/**
 An ImageDrawable is specialized to a specific kind of image -- most likely
 because its draw method involves drawing *an already rendered image*, such as a
 snapshot.
 */
protocol ImageDrawable {
  associatedtype ImageType
  func draw<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType
}
