import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var addStrokeButton: UIBarButtonItem!
  @IBOutlet weak var RedoButton: UIBarButtonItem!
  @IBOutlet weak var UndoButton: UIBarButtonItem!

  var canvasView: CanvasView {
    return view as! CanvasView
  }

  override func viewDidLoad() {
    canvasView.setup()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func redoStroke(sender: UIBarButtonItem) {
    canvasView.redoStroke()
  }

  @IBAction func addStroke(sender: UIBarButtonItem) {
    canvasView.addStroke()
  }

  @IBAction func undoStroke(sender: UIBarButtonItem) {
    canvasView.undoStroke()
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    canvasView.drawTouches(touches, withEvent: event)
    canvasView.endTouches(touches, cancel: false)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    guard let touches = touches else { return }
    canvasView.endTouches(touches, cancel: true)
  }

  override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
    /// TODO once I have a device that calls this.
  }
}

