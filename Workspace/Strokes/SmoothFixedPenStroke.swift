/**
 A FixedPenStroke is a specific kind of stroke -- it has no variation in width,
 nor any roundness; it's just a line.
 */
class SmoothFixedPenStroke : Stroke {
  let brush_size: Double = 1
  override var undrawnPointOffset: Int { return 3 }

  func drawPoints(points: [Point], renderer: Renderer, initial: Bool=true, final: Bool=true) {
    renderer.moveTo(points[initial ? 0 : 1])
    
    guard points.count > 2 else {
      if initial && final {
        renderer.linear(points)
      }
      return
    }

    renderer.catmullRom(points, initial:  initial, final: final)
    renderer.stroke(1)
  }

  override func draw(renderer: Renderer) {
    drawPoints(points + predictedPoints, renderer: renderer)
  }

  override func drawUndrawnPoints(renderer: Renderer) {
    drawPoints(undrawnPoints(), renderer: renderer, initial: undrawnPoints().count == points.count, final: false)

    undrawnPointIndex = nil
  }

  override func drawPredictedPoints(renderer: Renderer) {
    // Because Catmull-Rom makes use previous and next points to calculate 
    // control points, we have to hand the renderer a few previous points in 
    // addition to the predicted points themselves.
    let start = max(0, points.count - undrawnPointOffset)
    let newPoints = Array(points[start..<points.count] + predictedPoints)
    drawPoints(newPoints, renderer: renderer, initial: false)
  }
}
