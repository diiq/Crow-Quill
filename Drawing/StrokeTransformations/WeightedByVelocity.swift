struct WeightedByVelocity : StrokeTransformation {
  let scale: Double

  func apply(points: [StrokePoint]) -> [StrokePoint] {
    return points.slidingWindow { focus, before, after in
      guard let point = before ?? after else { return nil }
      var weight = self.scale * self.scale / ((focus - point).length() + 0.01)
      weight = max(min(weight, self.scale), 0.5)
      return StrokePoint(x: focus.x, y: focus.y, weight: weight)
    }
  }
}