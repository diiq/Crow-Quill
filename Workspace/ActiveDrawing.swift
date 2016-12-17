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
  var strokeFactory: ((_ points: [Point], _ transforms: [StrokeTransformation]) -> Stroke)!
  var scalar: Double = 1

  func updateStroke(_ index: IndexType, points: [Point], transforms: [StrokeTransformation]) {
    let stroke = strokesByIndex[index] ?? newStrokeForIndex(index, transforms: transforms)
    for point in points {
      stroke.addPoint(point)
    }
  }

  func updateStrokePredictions(_ index: IndexType, points: [Point]) {
    guard let stroke = strokesByIndex[index] else { return }
    for point in points {
      stroke.addPredictedPoint(point)
    }
  }

  func endStroke(_ index: IndexType, viewTransform: StrokeTransformation) -> Stroke? {
    guard let stroke = strokesByIndex[index] else { return nil }
    strokesByIndex.removeValue(forKey: index)
    stroke.finalize(viewTransform)
    frozen = nil
    print("returning", stroke.pointCount())
    return stroke
  }

  /**
   Returns a tuple that can be passed to CGRect. That rect will contain all
   parts of the ActiveDrawing that need to be redrawn at the next update.
   */
  func rectForUpdatedPoints() -> (x: Double, y: Double, width: Double, height: Double) {
    let rects = strokesByIndex.values.map { $0.undrawnRect() }
    let maxX = (rects.map { $0.maxX }).max()!
    let maxY = (rects.map { $0.maxY }).max()!
    let minX = (rects.map { $0.minX }).min()!
    let minY = (rects.map { $0.minY }).min()!

    return (x: minX, y: minY, width: maxX - minX, height: maxY - minY)
  }

  func forgetPredictions(_ index: IndexType) {
    guard let stroke = strokesByIndex[index] else { return }
    stroke.forgetPredictions()
  }

  func draw<R: ImageRenderer>(_ renderer: R) where R.ImageType == ImageType {
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

  fileprivate func newStrokeForIndex(_ index: IndexType, transforms: [StrokeTransformation]) -> Stroke {
    // TODO: How to choose the stroke type
    var line = strokeFactory([], transforms)
    line.brushScale = scalar
    strokesByIndex[index] = line
    return line
  }
}
