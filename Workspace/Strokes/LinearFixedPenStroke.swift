/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearFixedPenStroke : Stroke {
  let brushSize: Double = 1

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool, final: Bool) {
    renderer.linear(points)
    renderer.stroke(brushSize)
    undrawnPointIndex = nil
  }
}
