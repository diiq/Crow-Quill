import Darwin
// These are compound methods that build on the universal atoms defined in the
// Renderer protocol.
typealias BezierPoints = (a: Point, cp1: Point, cp2: Point, b: Point)

extension Renderer {
  func stampedLine(start start: Point, end: Point, stamper: (point: Point, renderer: Renderer) -> (), minimumGap: Double) {
    guard (end - start).length() > minimumGap else { return }
    let midPoint = (start + ((end - start) / 2)).withWeight((start.weight + end.weight) / 2)
    stamper(point: midPoint, renderer: self)
    stampedLine(start: start, end: midPoint, stamper: stamper, minimumGap: minimumGap)
    stampedLine(start: midPoint, end: end, stamper: stamper, minimumGap: minimumGap)
  }
  
  func stampedLinear(points: [Point], stamper: (point: Point, renderer: Renderer) -> (), minimumGap: Double) {
    var lastPoint = points[0]
    points[1..<points.count].forEach {
      stamper(point: lastPoint, renderer: self)
      stampedLine(start: lastPoint, end: $0, stamper: stamper, minimumGap: minimumGap)
      lastPoint = $0
    }
  }

  func stampedBezier(
    points: BezierPoints,
    stamper: (point: Point, renderer: Renderer) -> (),
    minimumGap: Double,
    tStart: Double = 0,
    tEnd: Double = 1) {
      let start = bezierPoint(points, t: tStart)
      let end = bezierPoint(points, t: tEnd)
      guard (start - end).length() > minimumGap else { return }
      let tMid = tStart + (tEnd - tStart)/2
      let midPoint = bezierPoint(points, t: tMid)
      stamper(point: midPoint, renderer: self)
      stampedBezier(points, stamper: stamper, minimumGap: minimumGap, tStart: tStart, tEnd: tMid)
      stampedBezier(points, stamper: stamper, minimumGap: minimumGap, tStart: tMid, tEnd: tEnd)
  }


  // Returns a point along a smooth bezier curve, where 0 <= t <= 1
  func bezierPoint(points: BezierPoints, t: Double) -> Point {
    let aContrib = pow(1 - t, 3) * points.a
    let cp1Contrib = 3 * pow((1 - t), 2) * t * points.cp1
    let cp2Contrib = 3 * (1 - t) * pow(t, 2) * points.cp2
    let bContrib = pow(t, 3) * points.b
    let weight = points.a.weight + t*(points.b.weight - points.a.weight)
    return (aContrib + cp1Contrib + cp2Contrib + bContrib).withWeight(weight)
  }
}
