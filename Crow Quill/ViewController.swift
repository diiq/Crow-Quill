import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var drawing: DrawingView!
  @IBOutlet weak var activeDrawing: ActiveDrawingView!
  var gestureDelegate: CanvasGestureDelegate!

  override func viewDidLoad() {
    gestureDelegate = CanvasGestureDelegate(view: view, drawing: drawing)
    activeDrawing.drawing = drawing
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    activeDrawing.drawTouches(touches, withEvent: event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    activeDrawing.drawTouches(touches, withEvent: event)
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    activeDrawing.drawTouches(touches, withEvent: event)
    activeDrawing.endTouches(touches)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    guard let touches = touches else { return }
    activeDrawing.cancelTouches(touches)
  }

  override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
    /// TODO once I have a device that calls this.
  }

  override func shouldAutorotate() -> Bool {
    return false
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Landscape
  }
}

