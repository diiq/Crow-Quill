import UIKit

class CanvasView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var renderer: UIRenderer!
  let drawing = Drawing<CGImage>()
  let activeDrawing = ActiveDrawing()

  func setup() {
    renderer = UIRenderer(bounds: bounds)
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    renderer.context = context
    drawing.draw(renderer)
    activeDrawing.draw(renderer)
  }

  func undoStroke() {
    drawing.undoStroke()
    setNeedsDisplay()
  }

  func redoStroke() {
    drawing.redoStroke()
    setNeedsDisplay()
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