/**
 The ActiveDrawing represents just the strokes that are still incomplete -- 
 either because they're still being made, or because estimated properties have
 not yet been finalized.
 
 Unlike the Drawing proper, the ActiveDrawing needs to be very highly tuned to 
 draw *quickly*, to keep latency down. It attempts to only draw the most
 recent few points, and only rerender inside the rect that contains those points.
*/
class ActiveDrawing<I, IndexType: Hashable> : ImageDrawable {
  typealias ImageType = I
  var strokesByIndex = [IndexType : Stroke]()
  var frozen: ImageType? = nil
  var strokeFactory: ((points: [Point]) -> Stroke)!

  func addOrUpdateStroke(index: IndexType, points: [Point]) {
    let stroke = strokesByIndex[index] ?? newStrokeForIndex(index)
    for point in points {
      stroke.addPoint(point)
    }
  }

  func updateStrokePredictions(index: IndexType, points: [Point]) {
    guard let stroke = strokesByIndex[index] else { return }
    for point in points {
      stroke.addPredictedPoint(point)
    }
  }

  func endStroke(index: IndexType) -> Stroke? {
    guard let stroke = strokesByIndex[index] else { return nil }
    strokesByIndex.removeValueForKey(index)
    stroke.finalize()
    frozen = nil
    return stroke
  }

  /**
   Returns a tuple that can be passed to CGRect. That rect will contain all
   parts of the ActiveDrawing that need to be redrawn at the next update.
   */
  func rectForUpdatedPoints() -> (x: Double, y: Double, width: Double, height: Double) {
    let rects = strokesByIndex.values.map { $0.undrawnRect() }
    let maxX = (rects.map { $0.maxX }).maxElement()!
    let maxY = (rects.map { $0.maxY }).maxElement()!
    let minX = (rects.map { $0.minX }).minElement()!
    let minY = (rects.map { $0.minY }).minElement()!

    return (x: minX, y: minY, width: maxX - minX, height: maxY - minY)
  }

  func forgetPredictions(index: IndexType) {
    guard let stroke = strokesByIndex[index] else { return }
    stroke.predictedPoints = []
  }

  func draw<R: ImageRenderer where R.ImageType == ImageType>(renderer: R) {
    if frozen != nil {
      renderer.image(frozen!)
    }
    for stroke in strokesByIndex.values {
      stroke.drawUndrawnPoints(renderer)
    }
    frozen = renderer.currentImage
    for stroke in strokesByIndex.values {
      stroke.drawPredictedPoints(renderer)
    }
  }

  private func newStrokeForIndex(index: IndexType) -> Stroke {
    // TODO: How to choose the stroke type
    let line = strokeFactory(points: [])
    strokesByIndex[index] = line
    return line
  }
}