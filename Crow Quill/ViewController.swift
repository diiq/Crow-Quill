import UIKit
import QuartzCore

class ViewController: UIViewController {
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var drawingView: DrawingView!
  @IBOutlet weak var activeDrawingView: ActiveDrawingView!
  @IBOutlet weak var guideView: GuideView!

  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var undoButton: UIButton!
  @IBOutlet weak var guidesButton: UIButton!

  var workspace = Workspace<CGImage, UITouch>()
  var gestureDelegate: CanvasGestureDelegate!

  override func viewDidLoad() {
    gestureDelegate = CanvasGestureDelegate(
      view: activeDrawingView,
      drawing: drawingView,
      workspace: workspace)
    activeDrawingView.drawingView = drawingView
    activeDrawingView.setup(workspace)
    guideView.setup(workspace)
    drawingView.setup(workspace)
    workspace.viewTransform = ActiveSpaceToCanvasSpace(
      activeView: activeDrawingView,
      drawingView: drawingView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /// MARK Actions
  @IBAction func undo(sender: AnyObject) {
    workspace.undo()
    drawingView.setNeedsDisplay()
  }

  @IBAction func redo(sender: AnyObject) {
    workspace.redo()
    drawingView.setNeedsDisplay()
  }

  @IBAction func toggleGuides(sender: AnyObject) {
    workspace.toggleGuides()
    guideView.setNeedsDisplay()
  }

  @IBAction func choosePencil(sender: AnyObject) {
    workspace.activeDrawing.strokeFactory = SmoothFixedGuidedStroke.init
  }

  @IBAction func choosePen(sender: AnyObject) {
    workspace.activeDrawing.strokeFactory = SmoothVariableGuidedStroke.init
  }
}

