class SmoothVariableGuidedStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }

  override func drawPoints(start: Int, _ end: Int, renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))
    var guidedPoints = Array(points[start..<end])

    uncommittedTransforms.forEach { guidedPoints = $0.apply(guidedPoints) }

    //guidedPoints = WeightedByVelocity(scale: brushSize).apply(guidedPoints)
    //guidedPoints = ThreePointWeightAverage().apply(guidedPoints)

    renderer.weightedCatmullRom(guidedPoints, initial: initial, final: final)
    undrawnPointIndex = nil
  }

  override func undrawnPoints() -> [Point] {
    guard uncommittedTransforms.count == 0 else { return points }
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
