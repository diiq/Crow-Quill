/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedPenStroke : Stroke {
  let brush_size: Double = 1
  override var undrawnPointOffset: Int { return 3 }

  override func draw(renderer: Renderer) {
    guard points.count > 2 else {
      renderer.linear(points)
      return
    }

    renderer.catmullRom(points + predictedPoints)
    undrawnPointIndex = nil
  }

  override func drawUndrawnPoints(renderer: Renderer) {
    guard points.count > 2 else {
      renderer.linear(points)
      return
    }

    renderer.catmullRom(points + predictedPoints)
    undrawnPointIndex = nil
  }
}
