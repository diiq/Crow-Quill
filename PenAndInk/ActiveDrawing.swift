import UIKit

class ActiveDrawing {
  var strokesByTouch = [UITouch : Stroke]()

  func addOrUpdateStroke(indexTouch: UITouch, touches: [UITouch]) {
    var stroke = strokesByTouch[indexTouch] ?? newStrokeForTouch(indexTouch)
    for touch in touches {
      stroke.addPoint(touch)
    }
  }

  func updateStrokePredictions(indexTouch: UITouch, touches: [UITouch]) {
    guard var stroke = strokesByTouch[indexTouch] else { return }
    for touch in touches {
      stroke.addPredictedPoint(touch)
    }
  }

  func forgetPredictions(indexTouch: UITouch) {
    guard var stroke = strokesByTouch[indexTouch] else { return }
    stroke.predictedPoints = []
  }

  func newStrokeForTouch(touch: UITouch) -> Stroke {
    // TODO: How to choose the stroke type
    let line = SmoothFixedPenStroke(points: [])
    strokesByTouch[touch] = line
    return line
  }

  func endStrokeForTouch(touch: UITouch) -> Stroke? {
    guard var stroke = strokesByTouch[touch] else { return nil }
    strokesByTouch.removeValueForKey(touch)
    stroke.finalize()
    return stroke
  }

  func draw(renderer: Renderer) {
    for stroke in strokesByTouch.values {
      stroke.draw(renderer)
    }
  }
}