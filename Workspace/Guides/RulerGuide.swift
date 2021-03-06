
class RulerGuide : Guide {
  var handleA: Handle! = nil
  var handleB: Handle! = nil
  var width: Double = 50
  var active: Bool = true
  var transformation: StrokeTransformation {
    return ApplyRulerGuide(projector: projector())
  }
  
  init() {
    handleA = RulerHandle(point: Point(x: 200, y: 200), line: self)
    handleB = RulerHandle(point: Point(x: 800, y: 300), line: self)
  }
  
  var unitVector: Point {
    return (handleA.point - handleB.point).unit()
  }
  
  func boundary(_ renderer: Renderer) {
    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    let perp = unitVector.perpendicular() * width
    
    renderer.moveTo(start - perp)
    renderer.line(start - perp, end - perp)
    renderer.line(end - perp, end + perp)
    renderer.line(end + perp, start + perp)
    renderer.line(start + perp, start - perp)
  }
  
  func draw(_ renderer: Renderer) {
    renderer.color(GuideEdges)
    boundary(renderer)
    renderer.stroke(0.25)

    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    renderer.moveTo(start)
    renderer.line(start, end)
    renderer.stroke(1)

    handleA.draw(renderer)
    handleB.draw(renderer)
  }
  
  func projected(_ point: Point) -> Point {
    return unitVector.dot(point - handleA.point) * unitVector + handleA.point
  }

  func projector() -> (_ point: Point) -> Point {
    let permaUnit = unitVector
    let permaA = handleA.point
    return {
      return permaUnit.dot($0 - permaA) * permaUnit + permaA
    }
  }
  
  func handleFor(_ point: Point) -> Handle? {
    if handleA.pointInside(point) {
      return handleA
    } else if handleB.pointInside(point) {
      return handleB
    } else {
      return nil
    }
  }

  func appliesToPoint(_ point: Point) -> Bool {
    return (point - projected(point)).length() < width
  }
  
  func hystericalZone() -> Bool {
    return (handleB.point - handleA.point).length() < 100
  }
}
