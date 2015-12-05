import UIKit

class ActiveDrawingView: UIView {
  let isPredictionEnabled = UIDevice.currentDevice().userInterfaceIdiom == .Pad
  var workspace: Workspace<CGImage, UITouch>!
  var drawingView: DrawingView!

  func setup(workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
    workspace.activeDrawing.strokeFactory = SmoothVariablePenStroke.init
  }

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawActiveStrokes(renderer)
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    drawTouches(touches, withEvent: event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    drawTouches(touches, withEvent: event)
  }
  
  func drawTouches(indexTouches: Set<UITouch>, withEvent event: UIEvent?) {
    // TODO clean up this mess
    for indexTouch in indexTouches {
      workspace.forgetActiveStrokePredictions(indexTouch)

      let touches = event?.coalescedTouchesForTouch(indexTouch) ?? []
      workspace.updateActiveStroke(indexTouch, points: touches.map { $0.point() })

      if isPredictionEnabled {
        let predictedTouches = event?.predictedTouchesForTouch(indexTouch) ?? []
        workspace.updateActiveStrokePredictions(indexTouch, points: predictedTouches.map { $0.point() })
      }
    }
    setNeedsDisplayInRect(CGRect(workspace.activeDrawing.rectForUpdatedPoints()))
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