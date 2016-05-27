import UIKit

extension UIView {
  // Sets the point around which the transform, uh, transforms.
  func setAnchorPoint(anchorPoint: CGPoint) {
    var newPoint = CGPointMake(bounds.size.width * anchorPoint.x, bounds.size.height * anchorPoint.y)
    var oldPoint = CGPointMake(bounds.size.width * layer.anchorPoint.x, bounds.size.height * layer.anchorPoint.y)
    
    newPoint = CGPointApplyAffineTransform(newPoint, transform)
    oldPoint = CGPointApplyAffineTransform(oldPoint, transform)
    
    var position = layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x
    
    position.y -= oldPoint.y
    position.y += newPoint.y
    
    layer.position = position
    layer.anchorPoint = anchorPoint
  }
}