import UIKit

class DrawingView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var renderer: UIRenderer!
  var drawing = Drawing<CGImage>()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    if renderer == nil {
      renderer = UIRenderer(bounds: bounds)
    }
    renderer.context = context
    drawing.draw(renderer)
  }

  func undoStroke() {
    drawing.undoStroke()
    setNeedsDisplay()
  }

  func redoStroke() {
    drawing.redoStroke()
    setNeedsDisplay()
  }

  func addStroke(stroke: Stroke) {
    drawing.addStroke(stroke)
    setNeedsDisplay()
  }

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return false
  }
}