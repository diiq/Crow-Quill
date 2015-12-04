/**
Guides are made of three parts;

- the central line
- the tolerance marks
- the handles, which can both move the guide and be moved by it
- tolerance handles, which adjust the tolerance and move with tolerance marks.


Should these be drawables?
Is there something simpler that can be done?
*/

class Guide : Drawable {
  var handleA: Handle! = nil
  var handleB: Handle! = nil
  var width: Double = 50
  
  private var center: Handle {
    return handleA
  }
  
  private var direction: Handle {
    return handleB
  }
  
  init() {
    handleA = NormalHandle(point: Point(x: 200, y: 200), line: self)
    handleB = NormalHandle(point: Point(x: 800, y: 300), line: self)
  }

  var unitVector: Point {
    return (center.point - direction.point).unit()
  }

  func boundary(renderer: Renderer) {
    let start = center.point - 10000 * unitVector
    let end = center.point + 10000 * unitVector
    let perp = unitVector.perpendicular() * width

    renderer.moveTo(start + perp)
    renderer.line(start + perp, end + perp)
    renderer.line(end + perp, end - perp)
    renderer.line(end - perp, start - perp)
    renderer.line(start - perp, start + perp)
  }

  func draw(renderer: Renderer) {
    renderer.color(0.64, 0.86, 0.92, 0.75)

    let start = handleA.point - 10000 * unitVector
    let end = handleA.point + 10000 * unitVector
    renderer.moveTo(start)
    renderer.line(start, end)
    renderer.stroke()

    boundary(renderer)
    renderer.stroke()
    renderer.color(0.64, 0.86, 0.92, 0.25)
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
}
