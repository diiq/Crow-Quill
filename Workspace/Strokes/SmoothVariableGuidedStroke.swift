class SmoothVariableGuidedStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))
    var points = points

    if guideTransform != nil {
      points = guideTransform!.apply(points)
    }

    points = WeightedByVelocity(scale: brushSize).apply(points)
    points = ThreePointWeightAverage().apply(points)

    renderer.weightedCatmullRom(points, initial: initial, final: final)
    undrawnPointIndex = nil
  }
}
