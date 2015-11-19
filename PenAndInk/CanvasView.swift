import UIKit

class CanvasView: UIView {
  let renderer = UIRenderer()
  let drawing = Drawing<CGImage>()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    renderer.context = context
    drawing.draw(renderer)
    //CGContextDrawImage(context, bounds, renderer.currentImage)
  }

  func addStroke() {
    let points = (1...5).map { t -> StrokePoint in
      let x = arc4random_uniform(500)
      let y = arc4random_uniform(500)

      return StrokePoint(x: Double(x), y: Double(y), weight: 1)
    }
    drawing.addStroke(FixedPenStroke(points: points))

  }
}