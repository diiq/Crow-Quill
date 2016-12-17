import UIKit

struct ActiveSpaceToCanvasSpace : StrokeTransformation {
  let activeView: ActiveDrawingView
  let drawingView: DrawingView

  func apply(_ points: [Point]) -> [Point] {
    return points.map {
      let pt = drawingView.convert($0.cgPoint(), from: activeView)
      return pt.point().withWeight($0.weight / drawingView.scale)
    }
  }
}
