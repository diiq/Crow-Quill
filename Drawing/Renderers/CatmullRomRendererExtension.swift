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
  func catmullRom(points: [StrokePoint], initial: Bool=true, final: Bool=true) {
    let controlPoints1: [StrokePoint] = points.slidingWindow(catmullControlPoint)

    // Could also be points.reverse().slidingWindow(catmullControlPoint).reverse()
    // but that's slower and looks silly.
    let controlPoints2: [StrokePoint] = points.slidingWindow {
      focus, before, after in
      return self.catmullControlPoint(focus, before: after, after: before)
    }

    let start = initial ? 0 : 1
    let end = final ? points.count : points.count - 1
    for var i = start; i < end - 1; i++ {
      bezier(points[i], controlPoints1[i], controlPoints2[i+1], points[i+1])
    }
  }

  /**
   A control point is chosen in order to make the curve at p1 tangent to the
   line from p0 tp p2.
   */
  private func catmullControlPoint(focus: StrokePoint, before b: StrokePoint?, after a: StrokePoint?) -> StrokePoint {
    guard let before = b, after = a else { return focus }

    let d1 = (focus - before).length()
    let d2 = (after - focus).length()

    guard d1 > 0.0001 && d2 > 0.0001 else { return focus }

    var cp1 = after * d1 - before * d2
    cp1 = cp1 + focus * (2 * d1 + 3 * sqrt(d1) * sqrt(d2) + d2)
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
  func weightedCatmullRom(points: [StrokePoint]) {
    // This is done in two passes; one to get the outset points, and one to draw
    // the catmull-rom interpolation between those points.
    var outsetPointsForward = ForwardPerpendicularOutset().apply(points)
    var outsetPointsBack = BackwardPerpendicularOutset().apply(points)
    outsetPointsBack = outsetPointsBack.reverse()
    moveTo(outsetPointsForward[0])
    catmullRom(outsetPointsForward)
    arc(outsetPointsForward.last!, outsetPointsBack[0])
    catmullRom(outsetPointsBack)
    arc(outsetPointsBack.last!, outsetPointsForward[0])
    fill()
  }

}