class SmoothVariablePenStroke: SmoothFixedPenStroke {
  override var rectOffset: Double { return 50.0 }

  override func drawPoints(start: Int, _ end: Int, renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))
    
    var weightedPoints = Array(points[start..<end])
    weightedPoints = WeightedByVelocity(scale: brushSize * brushScale).apply(points)
    weightedPoints = ThreePointWeightAverage().apply(weightedPoints)
    
    renderer.weightedCatmullRom(weightedPoints, initial: initial, final: final)
    undrawnPointIndex = nil
  }
}
