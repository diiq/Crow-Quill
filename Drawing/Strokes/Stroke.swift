/**
 A stroke is a drawable that's made of a linear series of points.
 */

class Stroke: Drawable {
  var points: [Point] = []
  var predictedPoints: [Point] = []
  var undrawnPointIndex: Int? = 0
  var rectOffset: Double { return 10.0 }
  var undrawnPointOffset: Int { return 1 }

  init(points: [Point]) {
    self.points = points
  }

  func addPoint(point: Point) {
    if undrawnPointIndex == nil {
      undrawnPointIndex = max(points.count - undrawnPointOffset, 0)
      // [ done done gmove ] [ predicted predicted 
    }
    points.append(point)
  }

  func addPredictedPoint(point: Point) {
    predictedPoints.append(point)
  }

  func finalize() {
    predictedPoints = []
    undrawnPointIndex = nil
  }

  func draw(renderer: Renderer) {
    fatalError("Strokes must override draw")
  }

  func drawUndrawnPoints(renderer: Renderer) {
    fatalError("Strokes must override draw")
  }

  func drawPredictedPoints(renderer: Renderer) {
    fatalError("Strokes must override draw")
  }

  func undrawnPoints() -> [Point] {
    guard let start = undrawnPointIndex else { return [] }
    return Array(points[start..<points.count])
  }

  /**
   Returns a tuple that represents a rect which contains all as-yet-undrawn 
   segments of the stroke.
   
   The rect comes pre-outset, expanded by the stroke's rectOffset value on each 
   side. This prevents clipping, and also zero-area rects for horizontal 
   or vertical segments.
   */
  func undrawnRect() -> (minX: Double, minY: Double, maxX: Double, maxY: Double) {
    let points = undrawnPoints() + predictedPoints
    // This line might be wrong -- might cause over-drawing:
    guard points.count > 0 else { return (minX: 0, minY: 0, maxX: 0, maxY: 0) }

    let maxX = (points.map { $0.x }).maxElement()!
    let maxY = (points.map { $0.y }).maxElement()!
    let minX = (points.map { $0.x }).minElement()!
    let minY = (points.map { $0.y }).minElement()!
    return (
      minX: minX - rectOffset,
      minY: minY - rectOffset,
      maxX: maxX + rectOffset ,
      maxY: maxY + rectOffset)
  }
}