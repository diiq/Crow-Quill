import Darwin

// These are compound methods, that build on the universal atoms defined in the
// Renderer protocol.
extension Renderer {
  /**
   Draws a Centripital Catmull-Rom Spline through a set of points.

   This is a method for smoothly interpolating though all points, avoiding
   unexpected kinks or loops. See
   https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
   for more mathematical details.

   If initial is true, an additional bezier is added to include the first point
   (which is otherwise treated as an invisible control point)

   If final is true, an additional bezier is added to include the final point
   (which is otherwise treated as an invisible control point)
   */
  func catmullRom(_ points: [Point], initial: Bool=true, final: Bool=true) {
    let controlPoints1: [Point] = points.slidingWindow(catmullControlPoint)

    // Could also be points.reverse().slidingWindow(catmullControlPoint).reverse()
    // but that's slower and looks silly.
    let controlPoints2: [Point] = points.slidingWindow {
      focus, before, after in
      return self.catmullControlPoint(focus, before: after, after: before)
    }

    let start = initial ? 0 : 1
    let end = final ? points.count : points.count - 1
    for i in start ..< end - 1 {
      bezier(points[i], controlPoints1[i], controlPoints2[i+1], points[i+1])
    }
  }

  /**
   A control point is chosen in order to make the curve at p1 tangent to the
   line from p0 tp p2.
   */
  fileprivate func catmullControlPoint(_ focus: Point, before b: Point?, after a: Point?) -> Point {
    guard let before = b, let after = a else { return focus }

    let d1 = (focus - before).length()
    let d2 = (after - focus).length()

    guard d1 > 0.0001 && d2 > 0.0001 else { return focus }

    var cp1 = after * d1 - before * d2
    let part = (2 * d1 + 3 * sqrt(d1) * sqrt(d2) + d2)
    cp1 = cp1 + focus * part
    cp1 = cp1 * (1.0 / (3 * sqrt(d1) * (sqrt(d1) + sqrt(d2))))
    return cp1
  }

  /**
   Draws a Centripital Catmull-Rom Spline through a set of points, outset at 
   each point to be as wide as that point's weight.

   See
   https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
   for more mathematical details.
   */
  func weightedCatmullRom(_ points: [Point], initial: Bool=true, final: Bool=true) {
    // This is done in two passes; one to get the outset points, and one to draw
    // the catmull-rom interpolation between those points.
    if points.count < 2 {
      return
    }
    var outsetPointsForward = ForwardPerpendicularOutset().apply(points)
    var outsetPointsBack = BackwardPerpendicularOutset().apply(points)

    let fwdControlPoints1: [Point] = outsetPointsForward.slidingWindow(catmullControlPoint)
    let fwdControlPoints2: [Point] = outsetPointsForward.slidingWindow {
      focus, before, after in
      return self.catmullControlPoint(focus, before: after, after: before)
    }
    let bwdControlPoints1: [Point] = outsetPointsBack.slidingWindow(catmullControlPoint)
    let bwdControlPoints2: [Point] = outsetPointsBack.slidingWindow {
      focus, before, after in
      return self.catmullControlPoint(focus, before: after, after: before)
    }

    let start = initial ? 0 : 1
    let end = final ? points.count : points.count - 1
    for i in start ..< end - 1 {
      moveTo(outsetPointsForward[i])
      bezier(outsetPointsForward[i], fwdControlPoints1[i], fwdControlPoints2[i+1], outsetPointsForward[i+1])
      arc(outsetPointsForward[i+1], outsetPointsBack[i+1])
      bezier(outsetPointsBack[i+1], bwdControlPoints2[i+1], bwdControlPoints1[i], outsetPointsBack[i])
      arc(outsetPointsBack[i], outsetPointsForward[i])
      fill()
    }
  }

  func stampedCatmullRom(
    _ points: [Point],
    stamper: (_ point: Point, _ renderer: Renderer) -> (),
    minGap: Double,
    initial: Bool=true,
    final: Bool=true) {
      let controlPoints1: [Point] = points.slidingWindow(catmullControlPoint)

      let controlPoints2: [Point] = points.slidingWindow {
        focus, before, after in
        return self.catmullControlPoint(focus, before: after, after: before)
      }

      let start = initial ? 0 : 1
      let end = final ? points.count : points.count - 1
      guard start < end - 1 else { return }
      for i in start ..< end - 1 {
        stamper(points[i], self)
        let bezier = (a: points[i], cp1: controlPoints1[i], cp2: controlPoints2[i+1], b: points[i+1])
        stampedBezier(bezier, stamper: stamper, minimumGap: minGap)
      }
  }
}
