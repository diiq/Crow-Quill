import Darwin

struct ApplyRulerGuide : StrokeTransformation {
  let guide: RulerGuide

  func apply(points: [Point]) -> [Point] {
    return points.map {

      let projected = guide.projected($0)
      let direction = ($0 - projected).unit()
      let distance = ($0 - projected).length()
      return (projected + pow(distance, 0.5) * direction).withWeight($0.weight)
    }
  }
}