import Darwin

/**
 A Renderer is something that gets handed to a drawable and produces an image.

 That image can be any type at all; for tests our 'images' are arrays of strings.
 This protocol is a complete listing of all drawing methods necessary to render
 an image. These should remain backwards-compatible, so that existing images can
 still be opened and re-rendered.

 Be sure to check out [the WWDC talk](https://developer.apple.com/videos/play/wwdc2015-408/)
 that inspired this rendering architecture.
 */
protocol Renderer {
  /// Draws a straight, unweighted, black line from <ax, ay> to <bx, by>
  func line(a: StrokePoint, _ b: StrokePoint)
  func arc(a: StrokePoint, _ b: StrokePoint)
  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint)
  func moveTo(point: StrokePoint)
  func stroke()
  func fill()
}

/**
 An ImageRenderer is a Renderer that can inser previously rendered images of its
 ImageType into the image its currently rendering. This is used for recording
 and displaying snapshots of the drawing, purely for performance reasons.
 */
protocol ImageRenderer: Renderer {
  typealias ImageType

  /// The rendered image
  var currentImage: ImageType { get }

  /// Places an existing image into the image being rendered.
  func image(image: ImageType)
}

// These are compound methods, that build on the universal atoms defined above.
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
    let start = initial ? 0 : 1
    let end = final ? points.count - 1 : points.count - 2

    for var i = start; i < end; ++i {
      let p1 = points[i]
      let p2 = points[i+1]

      let d2 = (p2 - p1).length()

      guard d2 > 0.0001 else { continue }

      let controlPoint1: StrokePoint = {
        if i > 0 {
          let p0 = points[i-1]
          return catmullControlPoint1(p0, p1: p1, p2: p2)
        } else {
          return p1
        }
      }()

      let controlPoint2: StrokePoint = {
        if i < points.count - 2 {
          let p3 = points[i+2]
          return catmullControlPoint2(p1, p2: p2, p3: p3)
        } else {
          return p2
        }
      }()
      
      bezier(p1, controlPoint1, controlPoint2, p2)
    }
  }

  private func catmullControlPoint1(p0: StrokePoint, p1: StrokePoint, p2: StrokePoint) -> StrokePoint {
    let d2 = (p2 - p1).length()
    let d1 = (p1 - p0).length()

    guard d1 > 0.0001 else { return p1 }

    var cp1 = p2 * d1
    cp1 = cp1 - p0 * d2
    cp1 = cp1 + p1 * (2 * d1 + 3 * sqrt(d1) * sqrt(d2) + d2)
    cp1 = cp1 * (1.0 / (3 * sqrt(d1) * (sqrt(d1) + sqrt(d2))))
    return cp1
  }

  private func catmullControlPoint2(p1: StrokePoint, p2: StrokePoint, p3: StrokePoint) -> StrokePoint {
    let d2 = (p2 - p1).length()
    let d3 = (p3 - p2).length()


    guard d3 > 0.0001 else { return p2 }

    var cp2 = p1 * d3
    cp2 = cp2 - p3 * d2
    cp2 = cp2 + p2 * (2 * d3 + 3 * sqrt(d3) * sqrt(d2) + d2)
    cp2 = cp2 * (1.0 / (3 * sqrt(d3) * (sqrt(d3) + sqrt(d2))))
    return cp2
  }

  func linear(points: [StrokePoint]) {
    var lastPoint = points[0]
    moveTo(lastPoint)
    points[1..<points.count].forEach {
      line(lastPoint, $0)
      lastPoint = $0
    }
  }

  func weightedLine(a: StrokePoint, _ b: StrokePoint) {
    let perpendicular = (b - a).perpendicular()
    let aPlus = a + perpendicular * a.weight
    let aMinus = a - perpendicular * a.weight
    let bPlus = b + perpendicular * b.weight
    let bMinus = b - perpendicular * b.weight

    moveTo(aPlus)
    line(aPlus, bPlus)
    arc(bPlus, bMinus)
    line(bMinus, aMinus)
    arc(aMinus, aPlus)
    fill()
  }

  func weightedLinear(points: [StrokePoint]) {
    var lastPoint = points[0]
    moveTo(lastPoint)
    points[1..<points.count].forEach {
      weightedLine(lastPoint, $0)
      lastPoint = $0
    }
  }

  func weightedCatmullRom(points: [StrokePoint]) {
    // This is done in two passes; one to get the outset points, and one to draw
    // the catmull-rom interpolation between those points.
    var outsetPointsForward: [StrokePoint] = []
    var outsetPointsBack: [StrokePoint] = []
    for var i = 1; i < points.count - 2; ++i {
      let a = points[i]
      let cp1 = points[i - 1]
      let cp2 = points[i + 1]
      let perpendicularA = (cp2 - cp1).perpendicular()
      outsetPointsForward.append(a + perpendicularA * a.weight)
      outsetPointsBack.append(a - perpendicularA * a.weight)
    }
    outsetPointsBack = outsetPointsBack.reverse()
    moveTo(outsetPointsForward[0])
    catmullRom(outsetPointsForward)
    arc(outsetPointsForward.last!, outsetPointsBack[0])
    catmullRom(outsetPointsBack)
    arc(outsetPointsBack.last!, outsetPointsForward[0])
    fill()
  }
}