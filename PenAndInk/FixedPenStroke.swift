/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width, nor any roundness; it's just a line.
*/
struct FixedPenStroke : Stroke {
  let points: [StrokePoint]
  let brush_size: Double = 1

  func draw(renderer: Renderer) {
    var lastPoint = points[0]
    points[1..<points.count].forEach {
      renderer.line(lastPoint.x, lastPoint.y, $0.x, $0.y)
      lastPoint = $0
    }
  }
}
