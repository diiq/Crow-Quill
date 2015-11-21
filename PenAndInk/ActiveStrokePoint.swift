/**
 This is a reference type for points that belong to strokes which are still
 being updated.
 
 They must be areference type because they must exist both in a linear array of 
 points and also in a dictionary of touches to points.
*/

class ActiveStrokePoint {
  var x: Double
  var y: Double

  init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}