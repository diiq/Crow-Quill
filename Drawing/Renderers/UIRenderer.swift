import UIKit

/// Renders drawables into a CGContext
class UIRenderer: Renderer, ImageRenderer {
  typealias ImageType = CGImage
  var bounds: CGRect
  var context : CGContext!
  let color = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1.0).CGColor
  var currentImage: ImageType {
    get {
      return CGBitmapContextCreateImage(context)!
    }
  }

  init(bounds: CGRect) {
    self.bounds = bounds
  }

  func moveTo(point: StrokePoint) {
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, CGFloat(point.x), CGFloat(point.y))
  }

  func line(a: StrokePoint, _ b: StrokePoint) {
    CGContextAddLineToPoint(context, CGFloat(b.x), CGFloat(b.y))
  }

  func arc(a: StrokePoint, _ b: StrokePoint) {
    let delta = b - a
    let center = a + delta / 2
    let radius = delta.length() / 2
    CGContextAddArc(context,
      CGFloat(center.x),
      CGFloat(center.y),
      CGFloat(radius),
      CGFloat((a - center).radians()),
      CGFloat((b - center).radians()),
      1)
  }

  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint) {
    CGContextAddCurveToPoint(
      context,
      CGFloat(cp1.x),
      CGFloat(cp1.y),
      CGFloat(cp2.x),
      CGFloat(cp2.y),
      CGFloat(b.x),
      CGFloat(b.y))
  }

  func stroke() {
    CGContextSetLineCap(context, .Round)
    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetLineWidth(context, 1)
    CGContextStrokePath(context)
  }

  func fill() {
    CGContextSetFillColorWithColor(context, color)
    CGContextClosePath(context)
    CGContextFillPath(context)
  }

  func image(image: ImageType) {
    // Gotta figure out scaling here.
    CGContextTranslateCTM(context, 0, bounds.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, bounds , image)
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -bounds.height);
  }
}