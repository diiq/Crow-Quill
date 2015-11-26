/**
 A stroke is a drawable that's made of a linear series of points.
 */
import UIKit

protocol Stroke : Drawable {
  var points: [StrokePoint] { get set }
  var predictedPoints: [StrokePoint] { get set }
}

extension Stroke {
  mutating func addPoint(touch: UITouch) {
    let location = touch.preciseLocationInView(touch.view)
    let point = StrokePoint(x: Double(location.x), y: Double(location.y), weight: 1)
    points.append(point)
  }

  mutating func addPredictedPoint(touch: UITouch) {
    let location = touch.preciseLocationInView(touch.view)
    let point = StrokePoint(x: Double(location.x), y: Double(location.y), weight: 1)
    predictedPoints.append(point)
  }

  mutating func finalize() {
    predictedPoints = []
  }
}