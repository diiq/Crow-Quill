import UIKit

class GuideView: UIView {
  var renderer: UIRenderer!
  var guide = Guide()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    if renderer == nil {
      renderer = UIRenderer(bounds: bounds)
    }

    guide.handleA.move(StrokePoint(x: 50, y: 1000))
    print(guide.handleA.point)
    renderer.context = context
    guide.draw(renderer)
  }
}