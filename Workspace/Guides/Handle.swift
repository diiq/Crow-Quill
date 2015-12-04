protocol Handle : Drawable {
  var point: Point { get }
  func move(newPoint: Point)
  func pointInside(point: Point) -> Bool
}

class NormalHandle: Handle {
  var point: Point
  var length: Double
  weak var line: Guide!
  let handleSize: Double = 35
  private var handleEnd: Point {
    let direction = line.unitVector.perpendicular()
    return point + direction * length
  }
  
  init(point: Point, line: Guide, length: Double = 100) {
    self.point = point
    self.line = line
    self.length = length
  }

  func draw(renderer: Renderer) {
    renderer.color(0.64, 0.86, 0.92, 0.75)
    let direction = line.unitVector.perpendicular()
    renderer.moveTo(point)
    renderer.line(point, handleEnd - handleSize * direction)
    renderer.stroke(1)
    renderer.circle(handleEnd, radius: handleSize)
    renderer.stroke(0.5)
    renderer.color(0.64, 0.86, 0.92, 0.25)
    renderer.circle(handleEnd, radius: handleSize)
    renderer.fill()
    
    renderer.color(0.64, 0.86, 0.92, 1)
    renderer.circle(handleEnd, radius: handleSize / 5)
    renderer.fill()
  }

  func pointInside(point: Point) -> Bool {
    return (point - handleEnd).length() < handleSize
  }

  func move(newPoint: Point) {
    let oldPoint = point
    let direction = line.unitVector.perpendicular()
    point = newPoint - (direction * length)
    if line.hystericalZone() {
      point = oldPoint
    } 
  }
}