
class RulerGuide : Guide {
  var handleA: Handle! = nil
  var handleB: Handle! = nil
  var width: Double = 50
  var active: Bool = true
  var transformation: StrokeTransformation {
    return ApplyRulerGuide(guide: self)
  }
  
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
    renderer.color(GuideFill)

    renderer.shadowOn()
    boundary(renderer)
    renderer.stroke(1)
    renderer.shadowOff()

    boundary(renderer)
    renderer.fill()

    renderer.color(GuideEdges)
    boundary(renderer)
    renderer.stroke(0.5)

    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    renderer.moveTo(start)
    renderer.line(start, end)
    renderer.stroke(1)

    handleA.draw(renderer)
    handleB.draw(renderer)
  }
  
  func projected(point: Point) -> Point {
    return unitVector.dot(point - handleA.point) * unitVector + handleA.point
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

  func appliesToPoint(point: Point) -> Bool {
    return (point - projected(point)).length() < width
  }
  
  func hystericalZone() -> Bool {
    return (handleB.point - handleA.point).length() < 100
  }
}
