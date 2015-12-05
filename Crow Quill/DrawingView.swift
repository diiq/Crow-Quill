import UIKit

class DrawingView: UIView {
  var workspace: Workspace<CGImage, UITouch>!

  func setup(workspace: Workspace<CGImage, UITouch>) {
    self.workspace = workspace
  }

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    let renderer = UIRenderer(bounds: bounds)
    renderer.context = context
    workspace?.drawDrawing(renderer)
  }

  func undoStroke() {
    workspace.undo()
    setNeedsDisplay()
  }

  func redoStroke() {
    workspace.redo()
    setNeedsDisplay()
  }
}