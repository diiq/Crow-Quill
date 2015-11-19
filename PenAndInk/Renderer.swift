// A renderer is something that takes a

protocol Renderer {
  func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double)
}

protocol ImageRenderer: Renderer {
  typealias ImageType: Image
  var currentImage: ImageType { get }
  func image(image: ImageType)
}

