
class RulerGuide : Guide {
  var handleA: Handle! = nil
  var handleB: Handle! = nil
  var width: Double = 50
  var active: Bool = true
  
  init() {
    handleA = RulerHandle(point: Point(x: 200, y: 200), line: self)
    handleB = RulerHandle(point: Point(x: 800, y: 300), line: self)
  }
  
  var unitVector: Point {
    return (handleA.point - handleB.point).unit()
  }
  
  func boundary(renderer: Renderer) {
    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    let perp = unitVector.perpendicular() * width
    
    renderer.moveTo(start + perp)
    renderer.line(start + perp, end + perp)
    renderer.line(end + perp, end - perp)
    renderer.line(end - perp, start - perp)
    renderer.line(start - perp, start + perp)
  }
  
  func draw(renderer: Renderer) {
    renderer.color(GuideColor)
    
    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    renderer.moveTo(start)
    renderer.line(start, end)
    renderer.stroke(1)
    
    boundary(renderer)
    renderer.stroke(0.5)
    renderer.color(r: 0.6, g: 0.6, b: 0.6, a: 0.125)
    boundary(renderer)
    renderer.fill()
    handleA.draw(renderer)
    handleB.draw(renderer)
  }
  
  func projected(point: Point) -> Point {
    return unitVector.dot(point) * unitVector
  }
  
  func handleFor(point: Point) -> Handle? {
    if handleA.pointInside(point) {
      return handleA
    } else if handleB.pointInside(point) {
      return handleB
    } else {
      return nil
    }
  }
  
  func hystericalZone() -> Bool {
    return (handleB.point - handleA.point).length() < 100
  }
}
