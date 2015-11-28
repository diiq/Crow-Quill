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
  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint)
  func moveTo(point: StrokePoint)
  func stroke()
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
    moveTo(points[start])

    for var i = start; i < end; ++i {
      let p1 = points[i]
      let p2 = points[i+1]

      let d2 = p2.deltaTo(p1).length()

      guard d2 > 0.0001 else { continue }

      let controlPoint1: StrokePoint = {
        if i > 0 {
          let p0 = points[i-1]
          let d1 = p1.deltaTo(p0).length()

          guard d1 > 0.0001 else { return p1 }

          var cp1 = p2.multiplyBy(d1)
          cp1 = cp1.deltaTo(p0.multiplyBy(d2))
          cp1 = cp1.addTo(p1.multiplyBy(2 * d1 + 3 * sqrt(d1) * sqrt(d2) + d2))
          cp1 = cp1.multiplyBy(1.0 / (3 * sqrt(d1) * (sqrt(d1) + sqrt(d2))))
          return cp1
        } else {
          return p1
        }
      }()

      let controlPoint2: StrokePoint = {
        if i < points.count - 2 {
          let p3 = points[i+2]
          let d3 = p3.deltaTo(p2).length()

          guard d3 > 0.0001 else { return p2 }

          var cp2 = p1.multiplyBy(d3)
          cp2 = cp2.deltaTo(p3.multiplyBy(d2))
          cp2 = cp2.addTo(p2.multiplyBy(2 * d3 + 3 * sqrt(d3) * sqrt(d2) + d2))
          cp2 = cp2.multiplyBy(1.0 / (3 * sqrt(d3) * (sqrt(d3) + sqrt(d2))))
          return cp2
        } else {
          return p2
        }
      }()
      
      bezier(p1, controlPoint1, controlPoint2, p2)
    }
  }
  
  func linear(points: [StrokePoint]) {
    var lastPoint = points[0]
    moveTo(lastPoint)
    points[1..<points.count].forEach {
      line(lastPoint, $0)
      lastPoint = $0
    }
  }
}