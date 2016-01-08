import UIKit

class CanvasGestureDelegate : NSObject, UIGestureRecognizerDelegate {
  private let canvasMotions: [UIGestureRecognizer]
  private let actions: [UIGestureRecognizer]
  let drawing: DrawingView
  let view: UIView
  let workspace: Workspace<CGImage, UITouch>
  private let pinchRecognizer = UIPinchGestureRecognizer()
  private let rotateRecognizer = UIRotationGestureRecognizer()
  private let panRecognizer: UIPanGestureRecognizer = {
    let it = UIPanGestureRecognizer()
    it.minimumNumberOfTouches = 2
    it.maximumNumberOfTouches = 2
    return it
  }()

  private let undoTapRecognizer: UITapGestureRecognizer = {
    let it = UITapGestureRecognizer()
    it.numberOfTouchesRequired = 2
    return it
  }()

  private let redoTapRecognizer: UITapGestureRecognizer = {
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

    pinchRecognizer.addTarget(self, action:"handleScale:")
    pinchRecognizer.delegate = self
    view.addGestureRecognizer(pinchRecognizer)

    rotateRecognizer.addTarget(self, action:"handleRotation:")
    rotateRecognizer.delegate = self
    view.addGestureRecognizer(rotateRecognizer)

    panRecognizer.addTarget(self, action:"handlePan:")
    panRecognizer.delegate = self
    view.addGestureRecognizer(panRecognizer)

    undoTapRecognizer.addTarget(self, action:"undoStroke:")
    undoTapRecognizer.delegate = self
    view.addGestureRecognizer(undoTapRecognizer)

    redoTapRecognizer.addTarget(self, action:"redoStroke:")
    view.addGestureRecognizer(redoTapRecognizer)
  }

  // TODO move this into view
  func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
    var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
    var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)

    newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)

    var position = view.layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x

    position.y -= oldPoint.y
    position.y += newPoint.y

    view.layer.position = position
    view.layer.anchorPoint = anchorPoint
  }

  func adjustAnchorPoint(gestureRecognizer: UIGestureRecognizer) {
    let locationInView = gestureRecognizer.locationInView(drawing)
    let anchorPoint = CGPoint(
      x: locationInView.x / drawing.bounds.size.width,
      y: locationInView.y / drawing.bounds.size.height)
    setAnchorPoint(anchorPoint, forView: drawing)
  }

  func handleScale(gestureRecognizer: UIPinchGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let scale = gestureRecognizer.scale
    guard drawing.scale * Double(scale) < 2 else { return }
    drawing.scale = drawing.scale * Double(scale)
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = CGAffineTransformScale(drawing.transform, scale, scale)

    gestureRecognizer.scale = 1.0
  }

  func handleRotation(gestureRecognizer: UIRotationGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let rotation = gestureRecognizer.rotation
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = CGAffineTransformRotate(drawing.transform, rotation)
    gestureRecognizer.rotation = 0
  }

  func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    guard ready(gestureRecognizer) else { return }
    let translation = gestureRecognizer.translationInView(drawing)
    adjustAnchorPoint(gestureRecognizer)
    drawing.transform = CGAffineTransformTranslate(drawing.transform, translation.x, translation.y)
    gestureRecognizer.setTranslation(CGPointZero, inView: drawing)
  }

  func undoStroke(gestureRecognizer: UITapGestureRecognizer) {
    drawing.undoStroke()
  }

  func redoStroke(gestureRecognizer: UIPanGestureRecognizer) {
    drawing.redoStroke()
  }

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return canvasMotions.contains(gestureRecognizer) && canvasMotions.contains(otherGestureRecognizer)
  }

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
    shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      let answer = canvasMotions.contains(otherGestureRecognizer) && gestureRecognizer == undoTapRecognizer
      return answer
  }

  private func ready(gestureRecognizer: UIGestureRecognizer) -> Bool {
    let state = gestureRecognizer.state
    return (state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed)
  }
}