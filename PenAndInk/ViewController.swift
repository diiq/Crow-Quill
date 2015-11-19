import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var addStrokeButton: UIButton!

  var canvasView: CanvasView {
    return view as! CanvasView
  }

  override func viewDidLoad() {
    canvasView.addStroke()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func addStroke(sender: UIButton) {
    canvasView.addStroke()
    canvasView.setNeedsDisplay()
  }
}

