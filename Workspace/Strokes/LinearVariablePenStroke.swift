/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearVariablePenStroke : Stroke {
  let brushSize: Double = 5
  override var rectOffset: Double { return 50.0 }
  override var undrawnPointOffset: Int { return 2 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool, final: Bool) {
    guard points.count > 2 else {
      return
    }

    var weightedPoints: [Point] = []
    for (var i = 1; i < points.count; i++) {
      let a = points[i]
      let aWeight = min(brushSize, (1/(a - points[i-1]).length() + 0.01) * brushSize * 5)
      weightedPoints.append(Point(x: a.x, y: a.y, weight: aWeight))
    }

    renderer.weightedLinear(weightedPoints)
    undrawnPointIndex = nil
  }
}
