import Darwin

struct ApplyRulerGuide : StrokeTransformation {
  let projector: (Point) -> Point
  let power: Double = 0.95
  let diminishingReturns = 0.1

  func apply(points: [Point]) -> [Point] {
    let distances: [Double] = points.map {
      let projected = projector($0)
      return ($0 - projected).length()
    }

    // Weighted average of distances, fading out
    let scale = log(diminishingReturns) / log(power)
    print(scale)
    var runningAverages: [Double] = []
    for var i = 0; i < distances.count; i++ {
      var sum: Double = 0
      var count: Double = 0
      var distance: Double = 0
      for var j = i; j >= 0 && distance < scale; j-- {
        distance = (points[j] - points[i]).length()
        sum += distances[j] * pow(0.95, distance)
        count += pow(0.95, distance)
      }
      distance = 0
      for var j = i; j < distances.count && distance < scale; j++ {
        distance = (points[j] - points[i]).length()
        sum += distances[j] * pow(0.95, distance)
        count += pow(0.95, distance)
      }
      count--
      sum -= distances[i]
      runningAverages.append(sum / count)
    }

    return zip(points, runningAverages).map {
      let projected = projector($0.0)
      let direction = ($0.0 - projected).unit()
      return ($0.0 - direction * $0.1).withWeight($0.0.weight)
    }
  }
}