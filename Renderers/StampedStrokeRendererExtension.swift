import Darwin
// These are compound methods that build on the universal atoms defined in the
// Renderer protocol.
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
  
  /*
  func stampedBezier(a: Point, _ cp1: Point, _ cp2: Point, _ b: Point,
    stamper: (point: Point, renderer: Renderer) -> (),
    minimumGap: Double,
    t: Double = 1) {
      let point = bezierPoint(a, cp1, cp2, b, t: t)
      guard (start - mid).length() > minimumGap else { return }
      let midPoint = (start + ((end - start) / 2)).withWeight((start.weight + end.weight) / 2)
      stamper(point: midPoint, renderer: self)
      stampedLine(start: start, end: midPoint, stamper: stamper, minimumGap: minimumGap)
      stampedLine(start: midPoint, end: end, stamper: stamper, minimumGap: minimumGap)
  }
  */
  
  // Returns a point along a smooth bezier curve, where 0 <= t <= 1
  func bezierPoint(a: Point, _ cp1: Point, _ cp2: Point, _ b: Point, t: Double) -> Point {
    let aContrib = pow(1 - t, 3) * a
    let cp1Contrib = 3 * pow((1 - t), 2) * t * cp1
    let cp2Contrib = 3 * (1 - t) * pow(t, 2) * cp2
    let bContrib = pow(t, 3) * b
    return aContrib + cp1Contrib + cp2Contrib + bContrib
  }
}
