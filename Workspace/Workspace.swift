/**
 The Workspace consists of the drawing, the active drawing, any guides that are 
 active, and any settings or state (like tool selection, etc)
*/

class Workspace<ImageType, IndexType: Hashable> {
  let activeDrawing = ActiveDrawing<ImageType, IndexType>()
  let drawing = Drawing<ImageType>()
  let guides = GuideCollection<IndexType>()
  var viewTransform: StrokeTransformation!

  // from active drawing
  func updateActiveStroke(index: IndexType, points: [Point]) {
    var transforms: [StrokeTransformation] = []
    if guides.transformationForIndex[index] != nil {
      transforms.append(guides.transformationForIndex[index]!)
    }
    activeDrawing.updateStroke(index, points: points, transforms: transforms)
  }

  func updateActiveStrokePredictions(index: IndexType, points: [Point]) {
    activeDrawing.updateStrokePredictions(index, points: points)
  }

  func forgetActiveStrokePredictions(index: IndexType) {
    activeDrawing.forgetPredictions(index)
  }

  func commitActiveStroke(index: IndexType) {
    guard let stroke = activeDrawing.endStroke(index, viewTransform: viewTransform) else { return }
    drawing.addStroke(stroke)
  }

  func cancelActiveStroke(index: IndexType) {
    activeDrawing.endStroke(index, viewTransform: viewTransform)
  }

  func drawActiveStrokes<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    activeDrawing.draw(renderer)
  }

  // From committed drawing
  func undo() {
    drawing.undoStroke()
  }

  func redo() {
    drawing.redoStroke()
  }

  func drawDrawing<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    drawing.draw(renderer)
  }

  // from guides
  func pointIsInGuideHandle(point: Point) -> Bool {
    return guides.pointInside(point)
  }

  func moveGuide(index: IndexType, point: Point) {
    guides.move(index, point: point)
  }

  func stopMovingGuide(index: IndexType) {
    guides.endMove(index)
  }

  func drawGuides<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    guides.draw(renderer)
  }

  func toggleGuides() {
    guides.toggleActive()
  }

  func setGuideTransform(index: IndexType, point: Point) {
    guides.setGuideTransformationForIndex(index, point: point)
  }

  /**
   // Still to come
   select/adjust tool
   activate/deactivate guide
  */
}



