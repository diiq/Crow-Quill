import Darwin

struct ApplyRulerGuide : StrokeTransformation {
  let projector: (Point) -> Point

  func apply(points: [Point]) -> [Point] {
    let distances: [Double] = points.map {
      let projected = projector($0)
      return ($0 - projected).length()
    }

    var runningAverages: [Double] = []
    for var i = 0; i < distances.count; i++ {
      let start = max(0, i - 15)
      let end = min(i + 16, distances.count)
      let sum = distances[start..<end].reduce(0, combine: +)
      let avg = sum / Double(end - start)
      runningAverages.append(avg)
    }

    return zip(points, runningAverages).map {
      let projected = projector($0.0)
      let direction = ($0.0 - projected).unit()
      return ($0.0 - direction * $0.1).withWeight($0.0.weight)
    }
  }
}