/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearVariablePenStroke : Stroke {
  let brushSize: Double = 5
  override var rectOffset: Double { return 50.0 }
  override var undrawnPointOffset: Int { return 2 }

  func drawPoints(points: [StrokePoint], renderer: Renderer) {
    guard points.count > 2 else {
      return
    }

    var weightedPoints: [StrokePoint] = []
    for (var i = 1; i < points.count; i++) {
      let a = points[i]
      let aWeight = min(brushSize, (1/(a - points[i-1]).length() + 0.01) * brushSize * 5)
      weightedPoints.append(StrokePoint(x: a.x, y: a.y, weight: aWeight))
    }

    renderer.weightedLinear(weightedPoints)
    undrawnPointIndex = nil
  }


  override func draw(renderer: Renderer) {
    drawPoints(points, renderer: renderer)
  }

  override func drawUndrawnPoints(renderer: Renderer) {
    drawPoints(undrawnPoints(), renderer: renderer)
  }

  override func drawPredictedPoints(renderer: Renderer) {
    drawPoints(points[points.count - 1..<points.count] + predictedPoints, renderer: renderer)
  }
}
