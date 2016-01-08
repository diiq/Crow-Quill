/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class LinearFixedPenStroke : BaseStroke {
  let brushSize: Double = 1

  override func drawPoints(start: Int, _ stop: Int, renderer: Renderer, initial: Bool, final: Bool) {
    renderer.linear(Array(points[start..<stop]))
    renderer.stroke(brushSize * brushScale)
    undrawnPointIndex = nil
  }
}
