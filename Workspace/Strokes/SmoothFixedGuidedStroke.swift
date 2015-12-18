/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedGuidedStroke : Stroke {
  let brushSize: Double = 1
  override var rectOffset: Double { return 80.0 }
  override var undrawnPointOffset: Int { return 100 }

  override func drawPoints(start: Int, _ stop: Int, renderer: Renderer, initial: Bool=true, final: Bool=true) {
    var guidedPoints = Array(points[start..<stop])
    renderer.color(NonPhotoBlue)

    guard guidedPoints.count > 2 else {
      if initial && final {
        renderer.moveTo(guidedPoints[0])
        renderer.linear(guidedPoints)
      }
      return
    }

    uncommittedTransforms.forEach { guidedPoints = $0.apply(guidedPoints) }

    renderer.moveTo(guidedPoints[initial ? 0 : 1])
    renderer.catmullRom(guidedPoints, initial:  initial, final: final)
    renderer.stroke(brushSize)
  }

  override func undrawnPoints() -> [Point] {
    guard uncommittedTransforms.count == 0 else { return finalPoints }
    return super.undrawnPoints()
  }

  override func drawPredictedPoints(renderer: Renderer) {
    guard uncommittedTransforms.count == 0 else {
      drawPoints(0, points.count, renderer: renderer)
      return
    }
    super.drawPredictedPoints(renderer)
  }

  override func drawUndrawnPoints(renderer: Renderer) {
    guard uncommittedTransforms.count == 0 else { return }
    super.drawUndrawnPoints(renderer)
  }
}
