/**
 A drawable is anything that has a draw method, which takes a renderer and produces an image.
 */
protocol Drawable {
  func draw(renderer: Renderer)
}

/**
 An ImageDrawable is specialized to a specific kind of image -- most likley because
 its draw method involves drawing *an already rendered image*, such as a snapshot.
 */
protocol ImageDrawable {
  typealias ImageType
  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R)
}