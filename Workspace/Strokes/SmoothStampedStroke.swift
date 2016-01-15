class SmoothStampedPenStroke: SmoothFixedPenStroke {
  let brushSizer: Double = 20

  override var rectOffset: Double { return 10.0 * brushSize }

  override func drawPoints(start: Int, _ end: Int, renderer: Renderer, initial: Bool=true, final: Bool=true) {
    func stamper(point: Point, renderer: Renderer) {
      renderer.circle(point, radius: point.weight * brushSize * brushScale)
      renderer.fill()
    }

    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))

    let weightedPoints = Array(points[start..<end])

    renderer.stampedCatmullRom(weightedPoints, stamper: stamper, minGap: brushSizer*brushScale*10, initial: initial, final: final)
    undrawnPointIndex = nil
  }
}
