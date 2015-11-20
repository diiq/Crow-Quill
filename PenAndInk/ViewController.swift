import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var addStrokeButton: UIButton!
  @IBOutlet weak var undoStrokeButton: UIButton!

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

  @IBAction func addStroke(sender: UIButton) {
    canvasView.addStroke()
  }

  @IBAction func undoStroke(sender: UIButton) {
    canvasView.undoStroke()
  }

}

