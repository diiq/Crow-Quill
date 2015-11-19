// This 'renders' images into an array of strings that are easy to test

typealias TestImage = [String]

class TestRenderer: Renderer, ImageRenderer {
  typealias ImageType = TestImage
  var currentImage: ImageType = ImageType()

  func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double) {
    currentImage.append("line: \(ax), \(ay), \(bx), \(by)")
  }

  func image(image: ImageType) {
    self.currentImage.appendContentsOf(image)
  }
}


