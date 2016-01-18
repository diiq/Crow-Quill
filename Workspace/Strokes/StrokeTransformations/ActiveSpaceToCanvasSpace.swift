import UIKit

struct ActiveSpaceToCanvasSpace : StrokeTransformation {
  let activeView: ActiveDrawingView
  let drawingView: DrawingView

  func apply(points: [Point]) -> [Point] {
    return points.map {
      let pt = drawingView.convertPoint($0.cgPoint(), fromView: activeView)
      return pt.point().withWeight($0.weight / drawingView.scale).withAltitude($0.altitude * drawingView.scale)
    }
  }
}