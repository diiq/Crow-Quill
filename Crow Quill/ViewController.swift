import UIKit

class ViewController: UIViewController {
  var gestureDelegate: CanvasGestureDelegate!
  @IBOutlet weak var canvas: CanvasView!

  override func viewDidLoad() {
    gestureDelegate = CanvasGestureDelegate(view: view, canvas: canvas)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvas.drawTouches(touches, withEvent: event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvas.drawTouches(touches, withEvent: event)
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvas.drawTouches(touches, withEvent: event)
    canvas.endTouches(touches)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    guard let touches = touches else { return }
    canvas.cancelTouches(touches)
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

