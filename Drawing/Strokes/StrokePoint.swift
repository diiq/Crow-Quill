import Darwin

/**
 A single point in a stroke. Doesn't *necessarily* correspond to a specific
 UITouch.
 */

struct StrokePoint {
  let x: Double
  let y: Double
  let weight: Double
  init(x: Double, y: Double, weight: Double = -1) {
    if x.isNaN || y.isNaN {
      // TODO For development env only. Remove before deploy.
      fatalError("NaNish point created.")
    }
    self.x = x
    self.y = y
    self.weight = weight
  }
}

extension StrokePoint : Equatable {}

func ==(left: StrokePoint, right: StrokePoint) -> Bool {
  return left.x == right.x && left.y == right.y && left.weight == right.weight
}

extension StrokePoint : CustomStringConvertible {
  var description: String {
    return "<\(x), \(y)>"
  }
}

// Maths
extension StrokePoint {
  func length() -> Double {
    return sqrt(x*x + y*y)
  }

  func unit() -> StrokePoint {
    let len = length()
    // Not sure this is the right solution to unitizing 0 length vector.
    guard len > 0 else { return StrokePoint(x: 0, y: 0, weight: weight) }
    return StrokePoint(x: x/len, y: y/len, weight: weight)
  }

  func perpendicular() -> StrokePoint {
    return StrokePoint(x: -y, y: x, weight: -1).unit()
  }

  func radians() -> Double {
    return atan2(y, x)
  }

  func dot(point: StrokePoint) -> Double {
    return x * point.x + y * point.y
  }
}

func *(left: StrokePoint, right: Double) -> StrokePoint {
  return StrokePoint(x: left.x * right, y: left.y * right, weight: -1)
}

func *(left: Double, right: StrokePoint) -> StrokePoint {
  return right * left
}

func /(left: StrokePoint, right: Double) -> StrokePoint {
  return StrokePoint(x: left.x / right, y: left.y / right, weight: -1)
}

func +(left: StrokePoint, right: StrokePoint) -> StrokePoint {
  return StrokePoint(x: left.x + right.x, y: left.y + right.y, weight: -1)
}

func -(left: StrokePoint, right: StrokePoint) -> StrokePoint {
  return StrokePoint(x: left.x - right.x, y: left.y - right.y, weight: -1)
}


import UIKit

extension UITouch {
  /**
   Returns a StrokePoint that mirrors the UITouch.

   Testing is miles easier not using apple's contructorless objects, so we want 
   to convert to a testing-friendly point type as high as possible in the 
   abstraction stack.
   */
  func strokePoint() -> StrokePoint {
    let location = preciseLocationInView(view)
    let weight = (type == .Stylus) ? force : -1
    return StrokePoint(x: Double(location.x), y: Double(location.y), weight: Double(weight))
  }
}

extension CGPoint {
  /**
   Returns a StrokePoint that mirrors the UITouch.

   Testing is miles easier not using apple's contructorless objects, so we want
   to convert to a testing-friendly point type as high as possible in the
   abstraction stack.
   */
  func strokePoint() -> StrokePoint {
    return StrokePoint(x: Double(x), y: Double(y))
  }
}