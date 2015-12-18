/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedGuidedStroke : Stroke {
  let brushSize: Double = 1
  override var rectOffset: Double { return 80.0 }
  override var undrawnPointOffset: Int { return 100 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    var points = points
    renderer.color(NonPhotoBlue)

    guard points.count > 2 else {
      if initial && final {
        renderer.moveTo(points[0])
        renderer.linear(points)
      }
      return
    }

    uncommittedTransforms.forEach { points = $0.apply(points) }

    renderer.moveTo(points[initial ? 0 : 1])
    renderer.catmullRom(points, initial:  initial, final: final)
    renderer.stroke(brushSize)
  }

  override func undrawnPoints() -> [Point] {
    guard uncommittedTransforms.count == 0 else { return points }
    return super.undrawnPoints()
  }

  override func drawPredictedPoints(renderer: Renderer) {
    guard uncommittedTransforms.count == 0 else {
      drawPoints(points + predictedPoints, renderer: renderer)
      return
    }
    super.drawPredictedPoints(renderer)
  }

  override func drawUndrawnPoints(renderer: Renderer) {
    guard uncommittedTransforms.count == 0 else { return }
    super.drawUndrawnPoints(renderer)
  }
}
