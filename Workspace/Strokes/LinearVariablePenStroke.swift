/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearVariablePenStroke : BaseStroke {
  let brushSize: Double = 5
  override var rectOffset: Double { return 50.0 }
  override var undrawnPointOffset: Int { return 2 }

  override func drawPoints(_ start: Int, _ stop: Int, renderer: Renderer, initial: Bool, final: Bool) {
    guard stop - start > 2 else {
      return
    }

    var weightedPoints: [Point] = []
    for i in start+1..<stop { // Swift 3 update; may need <= here?
      let a = points[i]
      let aWeight = min(brushSize * brushScale, (1/(a - points[i-1]).length() + 0.01) * brushSize  * brushScale * 5)
      weightedPoints.append(Point(x: a.x, y: a.y, weight: aWeight))
    }

    renderer.weightedLinear(weightedPoints)
    undrawnPointIndex = nil
  }
}
