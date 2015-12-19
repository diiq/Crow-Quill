import Darwin

/**
 A single point in a stroke. Doesn't *necessarily* correspond to a specific
 UITouch.
 */

struct Point {
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

  func withWeight(weight: Double) -> Point {
    return Point(x: x, y: y, weight: weight)
  }

  func cgPoint() -> CGPoint {
    return CGPoint(x: x, y: y)
  }
}

// Maths

extension Point {
  func length() -> Double {
    return sqrt(x*x + y*y)
  }
  
  func unit() -> Point {
    let len = length()
    // Not sure this is the right solution to unitizing 0 length vector.
    guard len > 0 else { return Point(x: 0, y: 0, weight: weight) }
    return Point(x: x/len, y: y/len, weight: weight)
  }
  
  func perpendicular() -> Point {
    return Point(x: -y, y: x, weight: -1).unit()
  }
  
  func radians() -> Double {
    return atan2(y, x)
  }
  
  func dot(point: Point) -> Double {
    return x * point.x + y * point.y
  }
  
  func downward() -> Point {
    return Point(x: x * y/abs(y), y: abs(y))
  }
}

// Operators

func *(left: Point, right: Double) -> Point {
  return Point(x: left.x * right, y: left.y * right, weight: -1)
}

func *(left: Double, right: Point) -> Point {
  return right * left
}

func /(left: Point, right: Double) -> Point {
  return Point(x: left.x / right, y: left.y / right, weight: -1)
}

func +(left: Point, right: Point) -> Point {
  return Point(x: left.x + right.x, y: left.y + right.y, weight: -1)
}

func -(left: Point, right: Point) -> Point {
  return Point(x: left.x - right.x, y: left.y - right.y, weight: -1)
}


extension Point : Equatable {}

func ==(left: Point, right: Point) -> Bool {
  return left.x == right.x && left.y == right.y && left.weight == right.weight
}

extension Point : CustomStringConvertible {
  var description: String {
    return "<\(x), \(y)>"
  }
}


import UIKit

extension UITouch {
  /**
   Returns a Point that mirrors the UITouch.

   Testing is miles easier not using apple's contructorless objects, so we want 
   to convert to a testing-friendly point type as high as possible in the 
   abstraction stack.
   */
  func point() -> Point {
    let location = preciseLocationInView(view)
    let weight = (type == .Stylus) ? force : -1
    return Point(x: Double(location.x), y: Double(location.y), weight: Double(weight))
  }
}

extension CGPoint {
  /**
   Returns a Point that mirrors the UITouch.

   Testing is miles easier not using apple's contructorless objects, so we want
   to convert to a testing-friendly point type as high as possible in the
   abstraction stack.
   */
  func point() -> Point {
    return Point(x: Double(x), y: Double(y))
  }
}