// This 'renders' images into a UIImage or something

import UIKit

class UIRenderer: Renderer, ImageRenderer {
  typealias ImageType = CGImage
  var currentImage: ImageType {
    get {
      return CGBitmapContextCreateImage(context)!
    }
  }

  var context : CGContext!

  func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double) {
    let color = UIColor.blueColor()
    CGContextSetStrokeColorWithColor(context, color.CGColor)

    CGContextBeginPath(context)

    CGContextMoveToPoint(context, CGFloat(ax), CGFloat(ay))
    CGContextAddLineToPoint(context, CGFloat(bx), CGFloat(by))

    CGContextSetLineWidth(context, 5)
    CGContextStrokePath(context)

  }

  func image(image: ImageType) {
    // Gotta figure out scaling here.
    CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1000, height: 1000), image)
  }
}


