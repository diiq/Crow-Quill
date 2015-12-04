typealias TestImage = [String]

/// 'Renders' images into an array of strings that are easy to test
class TestRenderer: Renderer, ImageRenderer {
  typealias ImageType = TestImage
  var currentImage: ImageType = ImageType()

  func line(a: StrokePoint, _ b: StrokePoint) {
    currentImage.append("line: \(a), \(b)")
  }

  func arc(a: StrokePoint, _ b: StrokePoint) {
    currentImage.append("arc: \(a), \(b)")
  }

  func circle(center: StrokePoint, radius: Double) {
    currentImage.append("circle: \(center), \(radius)")
  }

  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint) {
    currentImage.append("bezier: \(a), [\(cp1), \(cp2)], \(b)")
  }

  func image(image: ImageType) {
    self.currentImage.appendContentsOf(image)
  }

  func moveTo(point: StrokePoint) {
    currentImage.append("move: \(point)")
  }

  func stroke() {
    currentImage.append("stroke")
  }

  func fill() {
    currentImage.append("fill")
  }

  func clear() {
    self.currentImage = []
  }

  func color(r: Double, _ g: Double, _ b: Double, _ a: Double) {
    currentImage.append("color")
  }
}


