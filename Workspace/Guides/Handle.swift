protocol Handle : Drawable {
  var point: Point { get }
  func move(newPoint: Point)
  func pointInside(point: Point) -> Bool
}

class RulerHandle: Handle {
  var point: Point
  var length: Double
  weak var line: RulerGuide!
  let handleSize: Double = 35
  private var handleEnd: Point {
    let direction = line.unitVector.perpendicular()
    return point + direction * length
  }
  
  init(point: Point, line: RulerGuide, length: Double = 100) {
    self.point = point
    self.line = line
    self.length = length
  }

  func draw(renderer: Renderer) {
    renderer.color(r: 0.6, g: 0.6, b: 0.6, a: 0.75)
    let direction = line.unitVector.perpendicular()
    renderer.moveTo(point)
    renderer.line(point, handleEnd - handleSize * direction)
    renderer.stroke(1)
    renderer.circle(handleEnd, radius: handleSize)
    renderer.stroke(0.5)
    renderer.color(r: 0.6, g: 0.6, b: 0.6, a: 0.125)
    renderer.circle(handleEnd, radius: handleSize)
    renderer.fill()
    
    renderer.color(r: 0.6, g: 0.6, b: 0.6, a: 1)
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