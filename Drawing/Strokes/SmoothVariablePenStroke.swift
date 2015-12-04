class SmoothVariablePenStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }
  let brushSize: Double = 10

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    var weightedPoints: [Point] = WeightedByVelocity(scale: brushSize).apply(points)
    weightedPoints = ThreePointWeightAverage().apply(weightedPoints)

    renderer.weightedCatmullRom(weightedPoints, initial: initial, final: final)
    undrawnPointIndex = nil
  }
}
