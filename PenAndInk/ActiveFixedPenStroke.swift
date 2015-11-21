/**
 The 'active' version of a FixedPenStroke.
 
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
import UIKit

class ActiveFixedPenStroke : Stroke {
  var points: [ActiveStrokePoint] = []
  let brush_size: Double = 1
  var pointsByEstimationIndex = [Int: ActiveStrokePoint]()
  var isComplete: Bool {
    return pointsByEstimationIndex.count == 0
  }

  func draw(renderer: Renderer) {
    var lastPoint = points[0]
    points[1..<points.count].forEach {
      renderer.line(lastPoint.x, lastPoint.y, $0.x, $0.y)
      lastPoint = $0
    }
  }

  func updateWithTouch(touch: UITouch) {
    guard let estimationIndex = touch.estimationUpdateIndex else { return }

    let location = touch.preciseLocationInView(touch.view)
    let finished = !touch.estimatedProperties.contains(.Location)

    updatePoint(
      Int(estimationIndex),
      x: Double(location.x),
      y: Double(location.y),
      finished: finished)


    print("I updated this point.")
  }

  func updatePoint(estimationIndex: Int, x: Double, y: Double, finished: Bool = false) {
    let point = pointsByEstimationIndex[estimationIndex]
    guard point != nil else { return }
    point!.x = x
    point!.y = y
    if finished {
      pointsByEstimationIndex.removeValueForKey(estimationIndex)
    }
  }

  func addPoint(touch: UITouch) {
    let location = touch.preciseLocationInView(touch.view)
    let point = ActiveStrokePoint(x: Double(location.x), y: Double(location.y))
    points.append(point)
    if let estimationIndex = touch.estimationUpdateIndex {
      if !touch.estimatedProperties.contains(.Location) {
        pointsByEstimationIndex[Int(estimationIndex)] = point
      }
    }
  }
}
