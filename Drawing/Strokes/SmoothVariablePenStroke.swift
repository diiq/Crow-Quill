class SmoothVariablePenStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }
  let brushSize: Double = 5

  override func drawPoints(points: [StrokePoint], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    guard points.count > 2 else {
      return
    }

    var weightedPoints: [StrokePoint] = []
    for (var i = 1; i < points.count; i++) {
      let a = points[i]
      let aWeight = max(min(brushSize, (1/(a - points[i-1]).length() + 0.01) * brushSize * 5), 0.5)
      weightedPoints.append(StrokePoint(x: a.x, y: a.y, weight: aWeight))
    }

    guard weightedPoints.count > 4 else {
      renderer.weightedLinear(weightedPoints)
      return
    }

    if initial && weightedPoints.count >= 2 {
      renderer.weightedLine(weightedPoints[0], weightedPoints[1])
    }

    if final && weightedPoints.count > 2 {
      renderer.weightedLine(weightedPoints[weightedPoints.count - 2], weightedPoints[weightedPoints.count - 1])
      renderer.weightedLine(weightedPoints[weightedPoints.count - 3], weightedPoints[weightedPoints.count - 2])
    }

    renderer.weightedCatmullRom(weightedPoints)
    undrawnPointIndex = nil
  }
}
