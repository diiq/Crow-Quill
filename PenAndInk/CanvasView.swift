import UIKit

class CanvasView: UIView {
  var renderer: UIRenderer!
  let drawing = Drawing<CGImage>()
  // TODO move into activedrawing or something.
  // TODO try a map and see what happens
  var activeLinesByTouch = [UITouch : Stroke]()

  func setup() {
    renderer = UIRenderer(bounds: bounds)
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    renderer.context = context
    drawing.draw(renderer)
    for line in activeLinesByTouch.values {
      line.draw(renderer)
    }
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

  func redoStroke() {
    drawing.redoStroke()
    setNeedsDisplay()
  }

  func drawTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      var line = activeLinesByTouch[touch] ?? addActiveLineForTouch(touch)
      let coalescedTouches = event?.coalescedTouchesForTouch(touch) ?? []
      for cTouch in coalescedTouches {
        line.addPoint(cTouch)
      }
    }
    setNeedsDisplay()
  }

  func endTouches(touches: Set<UITouch>, cancel: Bool) {
    for touch in touches {
      guard let stroke = activeLinesByTouch[touch] else { continue }
      stroke.finalize()
      drawing.addStroke(stroke)
      activeLinesByTouch.removeValueForKey(touch)
      setNeedsDisplay()
    }
  }

  func updateEstimatedPropertiesForTouches(touches: Set<NSObject>) {
    // TODO: Nothing I own produces this event
  }

  func addActiveLineForTouch(touch: UITouch) -> Stroke {
    print("new line")
    let line = SmoothFixedPenStroke(points: [])
    activeLinesByTouch[touch] = line
    return line
  }
}