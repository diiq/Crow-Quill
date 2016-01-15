/**
 A VariablePenStroke varies its width with pressure or velocity. This one uses 
 linear interpolation.
 
 This class is used mostly for testing new ideas for strokes; linear
 interpolation is not good enough for production code.
 */
class LinearVariablePenStroke : BaseStroke {
  let brushSize: Double = 5
  override var rectOffset: Double { return 50.0 }
  override var undrawnPointOffset: Int { return 2 }

  override func drawPoints(start: Int, _ stop: Int, renderer: Renderer, initial: Bool, final: Bool) {
    guard stop - start > 2 else {
      return
    }

    var weightedPoints: [Point] = []
    for (var i = start+1; i < stop; i++) {
      let a = points[i]
      let aWeight = min(brushSize * brushScale, (1/(a - points[i-1]).length() + 0.01) * brushSize  * brushScale * 5)
      weightedPoints.append(Point(x: a.x, y: a.y, weight: aWeight))
    }

    renderer.weightedLinear(weightedPoints)
    undrawnPointIndex = nil
  }
}
