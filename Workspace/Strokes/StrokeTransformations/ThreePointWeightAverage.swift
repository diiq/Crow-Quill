struct ThreePointWeightAverage : StrokeTransformation {
  func apply(points: [Point]) -> [Point] {
    return points.slidingWindow { focus, before, after in
      var count: Double = 1
      var sum = focus.weight
      if before != nil {
        count += 1
        sum += before!.weight
      }
      if after != nil {
        count += 1
        sum += after!.weight
      }
      return Point(x: focus.x, y: focus.y, weight: sum/count)
    }
  }
}