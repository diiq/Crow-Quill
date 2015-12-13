import UIKit

class ActiveDrawingView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var workspace: Workspace<CGImage, UITouch>!
  var drawingView: DrawingView!

  func setup(workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
    workspace.activeDrawing.strokeFactory = SmoothVariableGuidedStroke.init
  }

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawActiveStrokes(renderer)
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      workspace.setGuideTransform(touch, point: touch.point())
      drawTouch(touch, withEvent: event)
    }
    setNeedsDisplayInRect(CGRect(workspace.activeDrawing.rectForUpdatedPoints()))
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      drawTouch(touch, withEvent: event)
    }
    setNeedsDisplayInRect(CGRect(workspace.activeDrawing.rectForUpdatedPoints()))
  }

  func drawTouch(indexTouch: UITouch, withEvent event: UIEvent?) {
    // TODO clean up this mess
    workspace.forgetActiveStrokePredictions(indexTouch)

    let touches = event?.coalescedTouchesForTouch(indexTouch) ?? []
    workspace.updateActiveStroke(indexTouch, points: touches.map { $0.point() })

    if isPredictionEnabled {
      let predictedTouches = event?.predictedTouchesForTouch(indexTouch) ?? []
      workspace.updateActiveStrokePredictions(indexTouch, points: predictedTouches.map { $0.point() })
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      workspace.commitActiveStroke(touch)
      drawingView.setNeedsDisplay()
    }
    setNeedsDisplay()
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    for touch in touches ?? [] {
      workspace.cancelActiveStroke(touch)
    }
    setNeedsDisplay()
  }

  override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
    /// TODO once I have a device that calls this.
  }
}