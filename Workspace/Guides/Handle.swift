protocol Handle : Drawable {
  var point: Point { get }
  func move(_ newPoint: Point)
  func pointInside(_ point: Point) -> Bool
}

class RulerHandle: Handle {
  var point: Point
  var length: Double = 40
  weak var line: RulerGuide!
  let handleSize: Double = 32
  fileprivate var handleEnd: Point {
    let direction = line.unitVector.perpendicular()
    return point + direction * length
  }
  
  init(point: Point, line: RulerGuide) {
    self.point = point
    self.line = line
  }

  func draw(_ renderer: Renderer) {
    renderer.color(GuideFill)

    renderer.shadowOn()
    renderer.circle(handleEnd, radius: handleSize)
    renderer.stroke(1)
    renderer.shadowOff()

    renderer.circle(handleEnd, radius: handleSize)
    renderer.fill()

    renderer.color(HandleEdges)
    if handleSize < length {
      let direction = line.unitVector.perpendicular()
      renderer.moveTo(point)
      renderer.line(point, handleEnd - handleSize * direction)
      renderer.stroke(1)
    }
    renderer.circle(handleEnd, radius: handleSize)
    renderer.stroke(0.5)
    
    renderer.circle(handleEnd, radius: handleSize / 5)
    renderer.fill()
  }

  func pointInside(_ point: Point) -> Bool {
    return (point - handleEnd).length() < handleSize
  }

  func move(_ newPoint: Point) {
    let oldPoint = point
    let direction = line.unitVector.perpendicular()
    point = newPoint - (direction * length)
    if line.hystericalZone() {
      point = oldPoint
    } 
  }
}
