import UIKit

class GuideView: UIView {
  var renderer: UIRenderer!
  var guide = Guide()
  var handleForTouch = [UITouch: Handle]()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    if renderer == nil {
      renderer = UIRenderer(bounds: bounds)
    }

    renderer.context = context
    guide.draw(renderer)
  }

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return guide.handleFor(point.point()) != nil
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guard let handle = guide.handleFor(touch.point()) else { continue }
      handleForTouch[touch] = handle
    }
    setNeedsDisplay()
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guard let handle = handleForTouch[touch] else { return }
      handle.move(touch.point())
    }
    setNeedsDisplay()
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in (event?.allTouches() ?? touches) {
      guard handleForTouch[touch] != nil else { return }
      handleForTouch.removeValueForKey(touch)
    }
    setNeedsDisplay()
  }
}