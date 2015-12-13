/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedGuidedStroke : Stroke {
  let brushSize: Double = 1
  override var rectOffset: Double { return 80.0 }
  override var undrawnPointOffset: Int { return 16 }

  override func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    var points = points
    renderer.color(NonPhotoBlue)

    guard points.count > 2 else {
      if initial && final {
        renderer.moveTo(points[0])
        renderer.linear(points)
      }
      return
    }

    if guideTransform != nil {
      points = guideTransform!.apply(points)
    }

    renderer.moveTo(points[initial ? 0 : 1])
    renderer.catmullRom(points, initial:  initial, final: final)
    renderer.stroke(brushSize)
  }
}
