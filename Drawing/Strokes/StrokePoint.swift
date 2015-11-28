import Darwin

/**
 A single point in a stroke. Doesn't *necessarily* correspond to a specific
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
  func length() -> Double {
    return sqrt(x*x + y*y)
  }

  func unit() -> StrokePoint {
    let len = length()
    return StrokePoint(x: x/len, y: y/len, weight: weight)
  }

  func perpendicular() -> StrokePoint {
    return StrokePoint(x: -y, y: x, weight: -1).unit()
  }

  func radians() -> Double {
    return atan2(y, x)
  }
}

func *(left: StrokePoint, right: Double) -> StrokePoint {
  return StrokePoint(x: left.x * right, y: left.y * right, weight: -1)
}

func *(left: Double, right: StrokePoint) -> StrokePoint {
  return right * left
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
    return StrokePoint(x: Double(location.x), y: Double(location.y), weight: 5)
  }
}