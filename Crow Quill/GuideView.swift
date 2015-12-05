import UIKit

class GuideView: UIView {
  var renderer: UIRenderer!
  var guides = GuideCollection<UITouch>()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    if renderer == nil {
      renderer = UIRenderer(bounds: bounds)
    }

    renderer.context = context
    guides.draw(renderer)
  }

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return guides.pointInside(point.point())
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guides.startMove(touch.point(), index: touch)
    }
    setNeedsDisplay()
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guides.continueMove(touch.point(), index: touch)
    }
    setNeedsDisplay()
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guides.endMove(touch.point(), index: touch)
    }
    setNeedsDisplay()
  }
}