class SmoothVariableGuidedStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))
    var points = points

    uncommittedTransforms.forEach { points = $0.apply(points) }

    points = WeightedByVelocity(scale: brushSize).apply(points)
    points = ThreePointWeightAverage().apply(points)

    renderer.weightedCatmullRom(points, initial: initial, final: final)
    undrawnPointIndex = nil
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
