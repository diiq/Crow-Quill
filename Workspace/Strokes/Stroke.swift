/**
 A stroke is a drawable that's made of a linear series of points.
 */

class Stroke: Drawable {
  var points: [Point] = []
  var predictedPoints: [Point] = []
  var undrawnPointIndex: Int? = 0
  var rectOffset: Double { return 10.0 }
  var uncommittedTransforms: [StrokeTransformation] = []
  
  /**
   If a new point is added to the line, how many previous points will we need
   to redraw?
   */
  var undrawnPointOffset: Int { return 1 }

  init(points: [Point], transforms: [StrokeTransformation] = []) {
    self.uncommittedTransforms = transforms
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
    uncommittedTransforms.forEach { points = $0.apply(points) }
    uncommittedTransforms = []
    undrawnPointIndex = nil
  }

  func drawPoints(points: [Point], renderer: Renderer, initial: Bool, final: Bool) {
    fatalError("Strokes must override draw")
  }

  func draw(renderer: Renderer) {
    drawPoints(
      points + predictedPoints,
      renderer: renderer,
      initial: true,
      final: true)
  }

  func drawUndrawnPoints(renderer: Renderer) {
    drawPoints(
      undrawnPoints(),
      renderer: renderer,
      initial: undrawnPoints().count == points.count,
      final: false)

    undrawnPointIndex = nil
  }

  func drawPredictedPoints(renderer: Renderer) {
    // We have to hand the renderer a few previous points in
    // addition to the predicted points themselves.
    let start = max(0, points.count - undrawnPointOffset)
    let newPoints = Array(points[start..<points.count] + predictedPoints)
    drawPoints(newPoints, renderer: renderer, initial: false, final: true)
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