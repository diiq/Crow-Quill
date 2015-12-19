import UIKit

class CanvasGestureDelegate : NSObject, UIGestureRecognizerDelegate {
  private let canvasMotions: [UIGestureRecognizer]
  private let actions: [UIGestureRecognizer]
  let drawing: DrawingView
  let view: UIView
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

  init(view: UIView, drawing: DrawingView) {
    self.drawing = drawing
    self.view = view
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

  func handleScale(gestureRecognizer: UIPinchGestureRecognizer) {
    guard readyWithView(gestureRecognizer) else { return }
    let scale = gestureRecognizer.scale
    drawing.transform = CGAffineTransformScale(drawing.transform, scale, scale)
    gestureRecognizer.scale = 1.0
  }

  func handleRotation(gestureRecognizer: UIRotationGestureRecognizer) {
    guard readyWithView(gestureRecognizer) else { return }
    let rotation = gestureRecognizer.rotation
    drawing.transform = CGAffineTransformRotate(drawing.transform, rotation)
    gestureRecognizer.rotation = 0
  }

  func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    guard readyWithView(gestureRecognizer) else { return }
    let translation = gestureRecognizer.translationInView(drawing)
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

  private func readyWithView(gestureRecognizer: UIGestureRecognizer) -> Bool {
    let state = gestureRecognizer.state
    return (state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed)
  }
}