typealias TestImage = [String]

/// 'Renders' images into an array of strings that are easy to test
class TestRenderer: Renderer, ImageRenderer {
  typealias ImageType = TestImage
  var currentImage: ImageType = ImageType()

  func line(_ a: Point, _ b: Point) {
    currentImage.append("line: \(a), \(b)")
  }

  func arc(_ a: Point, _ b: Point) {
    currentImage.append("arc: \(a), \(b)")
  }

  func circle(_ center: Point, radius: Double) {
    currentImage.append("circle: \(center), \(radius)")
  }

  func bezier(_ a: Point, _ cp1: Point, _ cp2: Point, _ b: Point) {
    currentImage.append("bezier: \(a), [\(cp1), \(cp2)], \(b)")
  }

  func image(_ image: ImageType) {
    self.currentImage.append(contentsOf: image)
  }

  func moveTo(_ point: Point) {
    currentImage.append("move: \(point)")
  }

  func stroke(_ lineWidth: Double) {
    currentImage.append("stroke")
  }

  func fill() {
    currentImage.append("fill")
  }

  func shadowOn() {
    currentImage.append("shadow on")
  }

  func shadowOff() {
    currentImage.append("shadow off")
  }

  func clear() {
    self.currentImage = []
  }

  func color(_ color: Color) {
    currentImage.append("color")
  }

  func placeImage(start: Point, width: Double, height: Double, name: String) {

  }
}


