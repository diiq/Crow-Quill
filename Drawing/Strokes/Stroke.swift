/**
 A stroke is a drawable that's made of a linear series of points.
 */

class Stroke: Drawable {
  var points: [StrokePoint] = []
  var predictedPoints: [StrokePoint] = []
  var undrawnPointIndex: Int? = 0
  let rectOffset = 10.0
  var undrawnPointOffset: Int { return 1 }

  init(points: [StrokePoint]) {
    self.points = points
  }

  func addPoint(point: StrokePoint) {
    undrawnPointIndex = max(points.count - undrawnPointOffset, 0)
    points.append(point)
  }

  func addPredictedPoint(point: StrokePoint) {
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
    draw(renderer)
  }

  func drawPredictedPoints(renderer: Renderer) {
    draw(renderer)
  }

  func undrawnPoints() -> [StrokePoint] {
    guard undrawnPointIndex != nil else { return [] }
    return points[undrawnPointIndex!..<points.count] + predictedPoints
  }

  func undrawnRect() -> (x: Double, y: Double, width: Double, height: Double) {
    let points = undrawnPoints()
    guard points.count > 0 else { return (x: 0, y: 0, width: 0, height: 0) }
    let maxX = (points.map { $0.x }).maxElement()!
    let maxY = (points.map { $0.y }).maxElement()!
    let minX = (points.map { $0.x }).minElement()!
    let minY = (points.map { $0.y }).minElement()!
    return (
      x: minX - rectOffset,
      y: minY - rectOffset,
      width: maxX - minX + rectOffset*2,
      height: maxY - minY + rectOffset*2)
  }
}