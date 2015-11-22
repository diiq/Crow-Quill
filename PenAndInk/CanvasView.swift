import UIKit

class CanvasView: UIView {
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
      let touches = event?.coalescedTouchesForTouch(indexTouch) ?? []
      activeDrawing.addOrUpdateStroke(indexTouch, touches: touches)
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