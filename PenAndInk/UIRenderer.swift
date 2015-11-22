import UIKit

/// Renders drawables into a CGContext
class UIRenderer: Renderer, ImageRenderer {
  typealias ImageType = CGImage
  var bounds: CGRect
  var context : CGContext!
  let color = UIColor(red:0.64, green:0.87, blue:0.93, alpha:1.0).CGColor
  var currentImage: ImageType {
    get {
      return CGBitmapContextCreateImage(context)!
    }
  }

  init(bounds: CGRect) {
    self.bounds = bounds
  }

  func line(a: StrokePoint, _ b: StrokePoint) {
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, CGFloat(a.x), CGFloat(a.y))
    CGContextAddLineToPoint(context, CGFloat(b.x), CGFloat(b.y))

    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetLineCap(context, .Round)
    CGContextSetLineWidth(context, 1)
    CGContextStrokePath(context)
  }

  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint) {
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, CGFloat(a.x), CGFloat(a.y))
    CGContextAddCurveToPoint(
      context,
      CGFloat(cp1.x),
      CGFloat(cp1.y),
      CGFloat(cp2.x),
      CGFloat(cp2.y),
      CGFloat(b.x),
      CGFloat(b.y))

    CGContextSetStrokeColorWithColor(context, color)
    CGContextSetLineWidth(context, 1)
    CGContextStrokePath(context)
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