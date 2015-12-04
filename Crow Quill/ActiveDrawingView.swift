import UIKit

class ActiveDrawingView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var renderer: UIRenderer!
  let activeDrawing = ActiveDrawing<CGImage, UITouch>()
  var drawing: DrawingView!
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    if renderer == nil {
      renderer = UIRenderer(bounds: bounds)
    }
    renderer.context = context
    activeDrawing.draw(renderer)
  }

  func drawTouches(indexTouches: Set<UITouch>, withEvent event: UIEvent?) {
    for indexTouch in indexTouches {
      activeDrawing.forgetPredictions(indexTouch)

      let touches = event?.coalescedTouchesForTouch(indexTouch) ?? []
      activeDrawing.addOrUpdateStroke(indexTouch, points: touches.map { $0.point() })

      if isPredictionEnabled {
        let predictedTouches = event?.predictedTouchesForTouch(indexTouch) ?? []
        activeDrawing.updateStrokePredictions(indexTouch, points: predictedTouches.map { $0.point() })
      }
    }
    setNeedsDisplayInRect(CGRect(activeDrawing.rectForUpdatedPoints()))
  }

  func endTouches(touches: Set<UITouch>) {
    for touch in touches {
      if let stroke = activeDrawing.endStroke(touch) {
        drawing.addStroke(stroke)
      }
    }
    setNeedsDisplay()
  }

  func cancelTouches(touches: Set<UITouch>) {
    for touch in touches {
      activeDrawing.endStroke(touch)
    }
    setNeedsDisplay()
  }

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return false
  }
}