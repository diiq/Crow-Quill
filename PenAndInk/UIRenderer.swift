// This 'renders' images into a UIImage or something

import UIKit

class UIRenderer: Renderer, ImageRenderer {
  typealias ImageType = CGImage
  var bounds: CGRect
  var context : CGContext!
  var currentImage: ImageType {
    get {
      return CGBitmapContextCreateImage(context)!
    }
  }

  init(bounds: CGRect) {
    self.bounds = bounds
  }

  func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double) {
    let color = UIColor.blackColor()
    CGContextSetStrokeColorWithColor(context, color.CGColor)
    CGContextSetLineCap(context, .Round)
    CGContextBeginPath(context)

    CGContextMoveToPoint(context, CGFloat(ax), CGFloat(ay))
    CGContextAddLineToPoint(context, CGFloat(bx), CGFloat(by))

    CGContextSetLineWidth(context, 5)
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


