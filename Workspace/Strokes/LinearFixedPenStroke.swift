/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearFixedPenStroke : Stroke {
  let brush_size: Double = 1

  override func draw(renderer: Renderer) {
    renderer.linear(points)
    renderer.stroke()
    undrawnPointIndex = nil
  }
}
