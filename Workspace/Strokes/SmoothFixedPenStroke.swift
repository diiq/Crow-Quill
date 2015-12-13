let NonPhotoBlue = Color(r: 0.64, g: 0.86, b: 0.93, a: 1)

/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedPenStroke : Stroke {
  let brushSize: Double = 1
  override var undrawnPointOffset: Int { return 3 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.color(NonPhotoBlue)

    guard points.count > 2 else {
      if initial && final {
        renderer.moveTo(points[0])
        renderer.linear(points)
      }
      return
    }

    renderer.moveTo(points[initial ? 0 : 1])
    renderer.catmullRom(points, initial:  initial, final: final)
    renderer.stroke(brushSize)
  }
}
