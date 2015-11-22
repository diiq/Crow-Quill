import UIKit

class ViewController: UIViewController {
  var gestureDelegate: CanvasMotionGestureDelegate!
  var canvasView: CanvasView {
    return view as! CanvasView
  }

  override func viewDidLoad() {
    canvasView.setup()
    gestureDelegate = CanvasMotionGestureDelegate(view: view, canvas: canvasView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
    canvasView.endTouches(touches)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    guard let touches = touches else { return }
    canvasView.cancelTouches(touches)
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

