import UIKit

struct ActiveSpaceToCanvasSpace : StrokeTransformation {
  let activeView: UIView
  let drawingView: UIView

  func apply(points: [Point]) -> [Point] {
    return points.map {
      let pt = drawingView.convertPoint($0.cgPoint(), fromView: activeView)
      return pt.point().withWeight($0.weight) // Gotta scale this
    }
  }
}