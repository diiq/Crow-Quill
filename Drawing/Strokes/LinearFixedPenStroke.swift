/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearFixedPenStroke : Stroke {
  var points: [StrokePoint]
  var predictedPoints: [StrokePoint] = []
  let brush_size: Double = 1

  init(points: [StrokePoint]) {
    self.points = points
  }

  func draw(renderer: Renderer) {
    renderer.linear(points)
  }
}
