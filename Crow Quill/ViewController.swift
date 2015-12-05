import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var drawing: DrawingView!
  @IBOutlet weak var activeDrawing: ActiveDrawingView!
  @IBOutlet weak var guides: GuideView!
  var workspace = Workspace<CGImage, UITouch>()
  var gestureDelegate: CanvasGestureDelegate!

  override func viewDidLoad() {
    gestureDelegate = CanvasGestureDelegate(view: view, drawing: drawing)
    activeDrawing.drawingView = drawing
    activeDrawing.setup(workspace)
    guides.setup(workspace)
    drawing.setup(workspace)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func shouldAutorotate() -> Bool {
    return false
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Landscape
  }
}

