import UIKit

class CanvasView: UIView {
  var renderer: UIRenderer!
  let drawing = Drawing<CGImage>()

  func setup() {
    renderer = UIRenderer(bounds: bounds)
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    renderer.context = context
    drawing.draw(renderer)
  }

  func addStroke() {
    var x = Int(arc4random_uniform(UInt32(bounds.width)))
    var y = Int(arc4random_uniform(UInt32(bounds.height)))
    let points = (1...500).map { t -> StrokePoint in
      x = x + Int(arc4random_uniform(11)) - 5
      y = y + Int(arc4random_uniform(11)) - 5

      return StrokePoint(x: Double(x), y: Double(y), weight: 1)
    }
    drawing.addStroke(FixedPenStroke(points: points))
    setNeedsDisplay()
  }

  func undoStroke() {
    drawing.undoStroke()
    setNeedsDisplay()
  }
}