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

}

