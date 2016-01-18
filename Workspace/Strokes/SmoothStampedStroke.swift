class SmoothStampedPenStroke: SmoothFixedPenStroke {
  let brushSizer: Double = 20

  override var rectOffset: Double { return 50.0 * brushSize }

  override func drawPoints(start: Int, _ end: Int, renderer: Renderer, initial: Bool=true, final: Bool=true) {
    func stamper(point: Point, renderer: Renderer) {
      let xoffset = Point(x: brushScale, y: 0)
      let yoffset = Point(x: 0, y: -10 * brushScale * (1 - (3.1415/(2*point.altitude))))
      renderer.moveTo(point - xoffset)
      renderer.line(point - xoffset, point + yoffset - xoffset)
      renderer.line(point + yoffset - xoffset, point + yoffset + xoffset)
      renderer.line(point + yoffset + xoffset, point + xoffset)
      renderer.line(point + xoffset, point - xoffset)
      renderer.fill()
    }

    renderer.color(Color(r: 0, g: 0, b: 0, a: 1))

    let weightedPoints = Array(points[start..<end])

    renderer.stampedCatmullRom(weightedPoints, stamper: stamper, minGap: 1, initial: initial, final: final)
    undrawnPointIndex = nil
  }
}
