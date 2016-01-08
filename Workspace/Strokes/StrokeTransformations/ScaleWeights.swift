struct ScaleWeights: StrokeTransformation {
  let scalar: Double
  func apply(points: [Point]) -> [Point] {
    return points.map {
      return $0.withWeight($0.weight * scalar)
    }
  }
}