import UIKit

/// Renders drawables into a CGContext
class UIRenderer: Renderer, ImageRenderer {
  typealias ImageType = CGImage
  var bounds: CGRect
  var context : CGContext!
  var currentColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1.0).cgColor
  var currentImage: ImageType {
    get {
      return context.makeImage()!
    }
  }

  init(bounds: CGRect) {
    self.bounds = bounds
  }

  func moveTo(_ point: Point) {
    context.beginPath()
    context.move(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
  }

  func line(_ a: Point, _ b: Point) {
    context.addLine(to: CGPoint(x: CGFloat(b.x), y: CGFloat(b.y)))
  }

  func arc(_ a: Point, _ b: Point) {
    let delta = b - a
    let center = a + delta / 2
    let radius = delta.length() / 2
    context.addArc(
      center: center.cgPoint(),
      radius: CGFloat(radius),
      startAngle: CGFloat((a - center).radians()),
      endAngle: CGFloat((b - center).radians()),
      clockwise: true)
  }

  func circle(_ center: Point, radius: Double) {
    context.addArc(
      center: center.cgPoint(),
      radius: CGFloat(radius),
      startAngle: 0,
      endAngle: 2*3.141593,
      clockwise: true)
  }

  func bezier(_ a: Point, _ cp1: Point, _ cp2: Point, _ b: Point) {
    context.addCurve(
      to: b.cgPoint(),
      control1: cp1.cgPoint(),
      control2: cp2.cgPoint()
    )
  }

  func color(_ color: Color) {
    currentColor = UIColor(
      red:CGFloat(color.r),
      green:CGFloat(color.g),
      blue:CGFloat(color.b),
      alpha:CGFloat(color.a)).cgColor
  }

  func stroke(_ lineWidth: Double) {
    context.setLineCap(.butt)
    context.setStrokeColor(currentColor)
    context.setLineWidth(CGFloat(lineWidth))
    context.strokePath()
  }

  func fill() {
    context.setFillColor(currentColor)
    context.closePath()
    (context).fillPath()
  }

  func shadowOn() {
    context.setShadow(offset: CGSize(width: 0, height: 0), blur: 1.5, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor)
  }

  func shadowOff() {
    context.setShadow(offset: CGSize(width: 0.5, height: 0.5), blur: 1, color: nil)
  }

  func image(_ image: ImageType) {
    // Gotta figure out scaling here.
    context.translateBy(x: 0, y: bounds.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.draw(image, in: bounds )
    context.scaleBy(x: 1.0, y: -1.0)
    context.translateBy(x: 0, y: -bounds.height)
  }

  func placeImage(start: Point, width: Double, height: Double, name: String) {
    let img = UIImage(named: "pencil.png")?.cgImage
    context.draw(img!, in: CGRect(x: start.x, y: start.y, width: width, height: height))
  }
}
