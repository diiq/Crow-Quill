import UIKit

class DrawingView: UIView {
  var workspace: Workspace<CGImage, UITouch>!
  var scale: Double = 1

  func setup(workspace: Workspace<CGImage, UITouch>) {
    self.backgroundColor = UIColor(patternImage: UIImage(named: "paper.png")!);
    self.workspace = workspace
    layer.allowsEdgeAntialiasing = true
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