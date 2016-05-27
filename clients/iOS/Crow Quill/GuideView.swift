import UIKit

class GuideView: UIView {
  var workspace: Workspace<CGImage, UITouch>!

  func setup(workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
  }

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawGuides(renderer)
  }

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return workspace.pointIsInGuideHandle(point.point())
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
    }
    setNeedsDisplay()
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
    }
    setNeedsDisplay()
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
      workspace.stopMovingGuide(touch)
    }
    setNeedsDisplay()
  }
}