import Darwin

struct ApplyRulerGuide : StrokeTransformation {
  let guide: RulerGuide

  func apply(points: [Point]) -> [Point] {
    let distances: [Double] = points.map {
      let projected = guide.projected($0)
      return ($0 - projected).length()
    }

    var runningAverages: [Double] = []
    for var i = 0; i < distances.count; i++ {
      let start = max(0, i - 5)
      let end = min(i + 6, distances.count)
      runningAverages.append(distances[start..<end].reduce(0, combine: +) / Double(end - start))
    }

    return zip(points, runningAverages).map {
      let projected = guide.projected($0.0)
      let direction = ($0.0 - projected).unit()
      return $0.0 - direction * $0.1
    }
  }
}