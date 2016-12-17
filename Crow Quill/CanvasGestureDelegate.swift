import UIKit

class CanvasGestureDelegate : NSObject, UIGestureRecognizerDelegate {
  fileprivate let canvasMotions: [UIGestureRecognizer]
  fileprivate let actions: [UIGestureRecognizer]
  let drawing: DrawingView
  let view: UIView
  let workspace: Workspace<CGImage, UITouch>
  fileprivate let pinchRecognizer = UIPinchGestureRecognizer()
  fileprivate let rotateRecognizer = UIRotationGestureRecognizer()
  fileprivate let panRecognizer: UIPanGestureRecognizer = {
    let it = UIPanGestureRecognizer()
    it.minimumNumberOfTouches = 2
    it.maximumNumberOfTouches = 2
    return it
  }()

  fileprivate let undoTapRecognizer: UITapGestureRecognizer = {
    let it = UITapGestureRecognizer()
    it.numberOfTouchesRequired = 2
    return it
  }()

  fileprivate let redoTapRecognizer: UITapGestureRecognizer = {
    let it = UITapGestureRecognizer()
    it.numberOfTouchesRequired = 3
    return it
  }()

  init(view: UIView, drawing: DrawingView, workspace: Workspace<CGImage, UITouch>) {
    self.drawing = drawing
    self.view = view
    self.workspace = workspace
    self.canvasMotions = [pinchRecognizer, rotateRecognizer, panRecognizer]
    self.actions = [undoTapRecognizer, redoTapRecognizer]
    super.init()

    pinchRecognizer.addTarget(self, action:#selector(CanvasGestureDelegate.handleScale(_:)))
    pinchRecognizer.delegate = self
    view.addGestureRecognizer(pinchRecognizer)

    rotateRecognizer.addTarget(self, action:#selector(CanvasGestureDelegate.handleRotation(_:)))
    rotateRecognizer.delegate = self
    view.addGestureRecognizer(rotateRecognizer)

    panRecognizer.addTarget(self, action:#selector(CanvasGestureDelegate.handlePan(_:)))
    panRecognizer.delegate = self
    view.addGestureRecognizer(panRecognizer)

    undoTapRecognizer.addTarget(self, action:#selector(CanvasGestureDelegate.undoStroke(_:)))
    undoTapRecognizer.delegate = self
    view.addGestureRecognizer(undoTapRecognizer)

    redoTapRecognizer.addTarget(self, action:#selector(CanvasGestureDelegate.redoStroke(_:)))
    view.addGestureRecognizer(redoTapRecognizer)
  }

  // TODO move this into view
  func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
    var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
    var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)

    newPoint = newPoint.applying(view.transform)
    oldPoint = oldPoint.applying(view.transform)

    var position = view.layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x

    position.y -= oldPoint.y
    position.y += newPoint.y

    view.layer.position = position
    view.layer.anchorPoint = anchorPoint
  }

  func adjustAnchorPoint(_ gestureRecognizer: UIGestureRecognizer) {
    let locationInView = gestureRecognizer.location(in: drawing)
    let anchorPoint = CGPoint(
      x: locationInView.x / drawing.bounds.size.width,
      y: locationInView.y / drawing.bounds.size.height)
    setAnchorPoint(anchorPoint, forView: drawing)
  }

  func handleScale(_ gestureRecognizer: UIPinchGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let scale = gestureRecognizer.scale
    guard drawing.scale * Double(scale) < 2 else { return }
    drawing.scale = drawing.scale * Double(scale)
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = drawing.transform.scaledBy(x: scale, y: scale)
    workspace.activeDrawing.scalar *= Double(scale)
    gestureRecognizer.scale = 1.0
  }

  func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let rotation = gestureRecognizer.rotation
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = drawing.transform.rotated(by: rotation)
    gestureRecognizer.rotation = 0
  }

  func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let translation = gestureRecognizer.translation(in: drawing)
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = drawing.transform.translatedBy(x: translation.x, y: translation.y)
    gestureRecognizer.setTranslation(CGPoint.zero, in: drawing)
  }

  func undoStroke(_ gestureRecognizer: UITapGestureRecognizer) {
    drawing.undoStroke()
  }

  func redoStroke(_ gestureRecognizer: UIPanGestureRecognizer) {
    drawing.redoStroke()
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return canvasMotions.contains(gestureRecognizer) && canvasMotions.contains(otherGestureRecognizer)
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      let answer = canvasMotions.contains(otherGestureRecognizer) && gestureRecognizer == undoTapRecognizer
      return answer
  }

  fileprivate func ready(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let state = gestureRecognizer.state
    return (state == UIGestureRecognizerState.began || state == UIGestureRecognizerState.changed)
  }
}
