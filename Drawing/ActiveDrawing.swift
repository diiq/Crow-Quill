/**
 TODO: Explain what this is for
*/
class ActiveDrawing<I, IndexType: Hashable> : ImageDrawable {
  typealias ImageType = I
  var strokesByIndex = [IndexType : Stroke]()
  var frozen: ImageType? = nil

  func addOrUpdateStroke(index: IndexType, points: [StrokePoint]) {
    let stroke = strokesByIndex[index] ?? newStrokeForIndex(index)
    for point in points {
      stroke.addPoint(point)
    }
  }

  func updateStrokePredictions(index: IndexType, points: [StrokePoint]) {
    guard let stroke = strokesByIndex[index] else { return }
    for point in points {
      stroke.addPredictedPoint(point)
    }
  }

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

  func newStrokeForIndex(index: IndexType) -> Stroke {
    // TODO: How to choose the stroke type
    let line = SmoothFixedPenStroke(points: [])
    strokesByIndex[index] = line
    return line
  }

  func endStroke(index: IndexType) -> Stroke? {
    guard let stroke = strokesByIndex[index] else { return nil }
    strokesByIndex.removeValueForKey(index)
    stroke.finalize()
    frozen = nil
    return stroke
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
}