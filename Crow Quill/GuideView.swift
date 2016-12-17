import UIKit

class GuideView: UIView {
  var workspace: Workspace<CGImage, UITouch>!

  func setup(_ workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawGuides(renderer)
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return workspace.pointIsInGuideHandle(point.point())
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
    }
    setNeedsDisplay()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
    }
    setNeedsDisplay()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      workspace.moveGuide(touch, point: touch.point())
      workspace.stopMovingGuide(touch)
    }
    setNeedsDisplay()
  }
}
