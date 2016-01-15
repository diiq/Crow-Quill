/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line. This one uses linear interpolation.
 
 This class is used mostly for testing new ideas for strokes; linear 
 interpolation is not good enough for production code.
 */
class LinearFixedPenStroke : BaseStroke {
  let brushSize: Double = 1

  override func drawPoints(start: Int, _ stop: Int, renderer: Renderer, initial: Bool, final: Bool) {
    renderer.linear(Array(points[start..<stop]))
    renderer.stroke(brushSize * brushScale)
    undrawnPointIndex = nil
  }
}
