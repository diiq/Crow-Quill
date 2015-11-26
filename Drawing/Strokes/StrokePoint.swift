import Darwin

/**
 A single point in a stroke. Doesn't necessarily correspond to a specific
 UITouch.
 */

struct StrokePoint {
  let x: Double
  let y: Double
  let weight: Double
}

extension StrokePoint : CustomStringConvertible {
  var description: String {
    return "<\(x), \(y)>"
  }
}

// Maths
extension StrokePoint {
  func addTo(a: StrokePoint) -> StrokePoint {
    return StrokePoint(x: x + a.x, y: y + a.y, weight: -1)
  }

  func deltaTo(a: StrokePoint) -> StrokePoint {
    return StrokePoint(x: x - a.x, y: y - a.y, weight: -1)
  }

  func multiplyBy(value: Double) -> StrokePoint {
    return StrokePoint(x: x * value, y: y * value, weight: -1)
  }

  func length() -> Double {
    return sqrt(x*x + y*y)
  }
}


