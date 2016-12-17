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
  func updateActiveStroke(_ index: IndexType, points: [Point]) {
    var transforms: [StrokeTransformation] = []
    if guides.transformationForIndex[index] != nil {
      transforms.append(guides.transformationForIndex[index]!)
    }
    activeDrawing.updateStroke(index, points: points, transforms: transforms)
  }

  func updateActiveStrokePredictions(_ index: IndexType, points: [Point]) {
    activeDrawing.updateStrokePredictions(index, points: points)
  }

  // rectforupdatedpoints

  func forgetActiveStrokePredictions(_ index: IndexType) {
    activeDrawing.forgetPredictions(index)
  }

  func commitActiveStroke(_ index: IndexType) {
    guard let stroke = activeDrawing.endStroke(index, viewTransform: viewTransform) else { return }
    drawing.addStroke(stroke)
  }

  func cancelActiveStroke(_ index: IndexType) {
    var _ = activeDrawing.endStroke(index, viewTransform: viewTransform)
  }

  func drawActiveStrokes<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType {
    activeDrawing.draw(renderer)
  }

  // From committed drawing
  func undo() {
    drawing.undoStroke()
  }

  func redo() {
    drawing.redoStroke()
  }

  func drawDrawing<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType {
    drawing.draw(renderer)
  }

  // from guides
  func pointIsInGuideHandle(_ point: Point) -> Bool {
    return guides.pointInside(point)
  }

  func moveGuide(_ index: IndexType, point: Point) {
    guides.move(index, point: point)
  }

  func stopMovingGuide(_ index: IndexType) {
    guides.endMove(index)
  }

  func drawGuides<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType {
    guides.draw(renderer)
  }

  func toggleGuides() {
    guides.toggleActive()
  }

  func setGuideTransform(_ index: IndexType, point: Point) {
    guides.setGuideTransformationForIndex(index, point: point)
  }

  /**
   // Still to come
   select/adjust tool
   activate/deactivate guide
  */
}



