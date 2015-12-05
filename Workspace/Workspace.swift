/**
 The Workspace consists of the drawing, the active drawing, any guides that are 
 active, and any settings or state (like tool selection, etc)
*/

class Workspace<ImageType, IndexType: Hashable> {
  let activeDrawing = ActiveDrawing<ImageType, IndexType>()
  let drawing = Drawing<ImageType>()
  let guides = GuideCollection<IndexType>()

  // from active drawing
  func updateActiveStroke(index: IndexType, points: [Point]) {}
  func commitActiveStroke(index: IndexType) {}
  func cancelActiveStroke(index: IndexType) {}
  func drawActiveStrokes<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {}

  // From committed drawing
  func undo() {}
  func redo() {}
  func drawDrawing<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {}

  // from guides
  func pointIsInGuideHandle(point: Point) -> Bool { return false }
  func moveGuide(index: IndexType, point: Point) {}
  func stopMovingGuide(index: IndexType) {}
  func drawGuides<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {}

  /**
   // Still to come
   select/adjust tool
   activate/deactivate guide
  */
}



