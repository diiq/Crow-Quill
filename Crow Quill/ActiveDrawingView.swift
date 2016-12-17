import UIKit

class ActiveDrawingView: UIView {
  var workspace: Workspace<CGImage, UITouch>!
  var drawingView: DrawingView!

  func setup(_ workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
    workspace.activeDrawing.strokeFactory = SmoothVariableGuidedStroke.init
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawActiveStrokes(renderer)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if touch.type == .stylus {
        workspace.setGuideTransform(touch, point: touch.point())
        drawTouch(touch, withEvent: event)
        let rect = workspace.activeDrawing.rectForUpdatedPoints()
        setNeedsDisplay(CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height))
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if touch.type == .stylus {
        drawTouch(touch, withEvent: event)
        let rect = workspace.activeDrawing.rectForUpdatedPoints()
        setNeedsDisplay(CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height))
      }
    }
  }

  func drawTouch(_ indexTouch: UITouch, withEvent event: UIEvent?) {
    // TODO clean up this mess
    workspace.forgetActiveStrokePredictions(indexTouch)

    let touches = event?.coalescedTouches(for: indexTouch) ?? []
    workspace.updateActiveStroke(indexTouch, points: touches.map { $0.point() })

    let predictedTouches = event?.predictedTouches(for: indexTouch) ?? []
    workspace.updateActiveStrokePredictions(indexTouch, points: predictedTouches.map { $0.point() })
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      workspace.commitActiveStroke(touch)
      drawingView.setNeedsDisplay()
    }
    setNeedsDisplay()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      workspace.cancelActiveStroke(touch)
    }
    setNeedsDisplay()
  }

  override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
    /// TODO once I have a device that calls this.
  }
}
