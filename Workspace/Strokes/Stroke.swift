/**
 A stroke is a drawable that's made of a linear series of points.
 */
protocol Stroke: Drawable {
  func draw(_ renderer: Renderer)
  func addPoint(_ point: Point)
  func addPredictedPoint(_ point: Point)
  func finalize(_ viewTransform: StrokeTransformation)
  func drawUndrawnPoints(_ renderer: Renderer)
  func drawPredictedPoints(_ renderer: Renderer)
  func undrawnRect() -> (minX: Double, minY: Double, maxX: Double, maxY: Double)
  func forgetPredictions()
  func pointCount() -> Int
  var brushScale: Double { get set }
}


class BaseStroke: Stroke {
  var brushScale: Double = 1
  var finalPoints: [Point] = []
  var predictedPoints: [Point] = []
  var undrawnPointIndex: Int? = 0
  var rectOffset: Double { return 10.0 }
  var uncommittedTransforms: [StrokeTransformation] = []
  var points: [Point] {
    return finalPoints + predictedPoints
  }
  /**
   If a new point is added to the line, how many previous points will we need
   to redraw?
   */
  var undrawnPointOffset: Int { return 1 }

  init(points: [Point], transforms: [StrokeTransformation] = []) {
    self.uncommittedTransforms = transforms
    self.finalPoints = points
  }

  func addPoint(_ point: Point) {
    if undrawnPointIndex == nil {
      undrawnPointIndex = max(finalPoints.count - undrawnPointOffset, 0)
      // [ done done gmove ] [ predicted predicted 
    }
    finalPoints.append(point)
  }

  func addPredictedPoint(_ point: Point) {
    predictedPoints.append(point)
  }

  func forgetPredictions() {
    predictedPoints = []
  }

  func finalize(_ viewTransform: StrokeTransformation) {
    // The viewTransform moves the stroke from the activeDrawing (which is 
    // in screen-space) into the drawing (which is in canvas-space). This is 
    // messed up, because of pixels.
    predictedPoints = []
    uncommittedTransforms.forEach { finalPoints = $0.apply(points) }
    uncommittedTransforms = []
    undrawnPointIndex = nil

    finalPoints = viewTransform.apply(finalPoints)
  }

  func drawPoints(_ start: Int, _ stop: Int, renderer: Renderer, initial: Bool, final: Bool) {
    fatalError("Strokes must override draw")
  }

  func draw(_ renderer: Renderer) {
    drawPoints(
      0,
      points.count,
      renderer: renderer,
      initial: true,
      final: true)
  }

  func drawUndrawnPoints(_ renderer: Renderer) {
    drawPoints(
      undrawnPointIndex ?? finalPoints.count,
      finalPoints.count,
      renderer: renderer,
      initial: undrawnPoints().count == finalPoints.count,
      final: false)

    undrawnPointIndex = nil
  }

  func drawPredictedPoints(_ renderer: Renderer) {
    // We have to hand the renderer a few previous points in
    // addition to the predicted points themselves.
    let start = max(0, finalPoints.count - undrawnPointOffset)
    drawPoints(start, points.count, renderer: renderer, initial: false, final: true)
  }

  func undrawnPoints() -> [Point] {
    guard let start = undrawnPointIndex else { return [] }
    return Array(finalPoints[start..<finalPoints.count])
  }

  func pointCount() -> Int {
    return points.count
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

    let maxX = (points.map { $0.x }).max()!
    let maxY = (points.map { $0.y }).max()!
    let minX = (points.map { $0.x }).min()!
    let minY = (points.map { $0.y }).min()!
    return (
      minX: minX - rectOffset,
      minY: minY - rectOffset,
      maxX: maxX + rectOffset ,
      maxY: maxY + rectOffset)
  }
}
