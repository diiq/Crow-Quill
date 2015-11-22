/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedPenStroke : Stroke {
  //var pointsByEstimationIndex = [Int : StrokePoint]()
  var points: [StrokePoint]
  let brush_size: Double = 1

  init(points: [StrokePoint]) {
    self.points = points
  }

  func draw(renderer: Renderer) {
    guard points.count > 4 else {
      renderer.linear(points)
      return
    }

    renderer.catmullRom(points)
  }
}
