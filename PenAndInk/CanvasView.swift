import UIKit

class CanvasView: UIView {
  var renderer: UIRenderer!
  let drawing = Drawing<CGImage>()
  // TODO move into activedrawing or something.
  // TODO try a map and see what happens
  var activeLinesByTouch = NSMapTable.strongToStrongObjectsMapTable()
  var activeLines: [ActiveFixedPenStroke] = []

  func setup() {
    renderer = UIRenderer(bounds: bounds)
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    renderer.context = context
    drawing.draw(renderer)
    for line in activeLines {
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
      let line = activeLinesByTouch.objectForKey(touch) as? ActiveFixedPenStroke ?? addActiveLineForTouch(touch)
      let coalescedTouches = event?.coalescedTouchesForTouch(touch) ?? []
      for cTouch in coalescedTouches {
        line.addPoint(cTouch)
      }
    }
    setNeedsDisplay()
  }

  func endTouches(touches: Set<UITouch>, cancel: Bool) {
    
  }

  func updateEstimatedPropertiesForTouches(touches: Set<NSObject>) {

  }



  func addActiveLineForTouch(touch: UITouch) -> ActiveFixedPenStroke {
    let line = ActiveFixedPenStroke()
    activeLinesByTouch.setObject(line, forKey: touch)
    activeLines.append(line)
    return line
  }
}