import UIKit

class ActiveDrawingView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var renderer: UIRenderer!
  let activeDrawing = ActiveDrawing()
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
      activeDrawing.addOrUpdateStroke(indexTouch, touches: touches)

      if isPredictionEnabled {
        let predictedTouches = event?.predictedTouchesForTouch(indexTouch) ?? []
        activeDrawing.updateStrokePredictions(indexTouch, touches: predictedTouches)
      }
    }
    setNeedsDisplay()
  }

  func endTouches(touches: Set<UITouch>) {
    for touch in touches {
      if let stroke = activeDrawing.endStrokeForTouch(touch) {
        drawing.addStroke(stroke)
      }
    }
    setNeedsDisplay()
  }

  func cancelTouches(touches: Set<UITouch>) {
    for touch in touches {
      activeDrawing.endStrokeForTouch(touch)
    }
    setNeedsDisplay()
  }
}