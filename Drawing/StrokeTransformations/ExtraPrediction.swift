struct ExtraPrediction : StrokeTransformation {
  func apply(points: [Point]) -> [Point] {
    guard points.count >= 2 else { return points }
    let last = points.last!
    let penultimate = points[points.count - 2]
    let loc = last + (last - penultimate)

    return points + [Point(x: loc.x, y: loc.y, weight: (last.weight + penultimate.weight) / 2)]
  }
}