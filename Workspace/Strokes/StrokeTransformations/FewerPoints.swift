struct FewerPoints : StrokeTransformation {
  func apply(points: [Point]) -> [Point] {
    guard points.count > 0 else { return [] }
    var res: [Point] = []
    for var i = 0; i < points.count; i = i + 2 {
      res.append(points[i])
    }

    if points.count % 2 == 0 {
      res.append(points.last!)
    }
    return res
  }
}