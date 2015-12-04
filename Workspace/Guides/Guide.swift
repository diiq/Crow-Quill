/**
Guides are made of three parts;

- the central line
- the tolerance marks
- the handles, which can both move the guide and be moved by it
- tolerance handles, which adjust the tolerance and move with tolerance marks.


Should these be drawables?
Is there something simpler that can be done?
*/
protocol Guide : Drawable {
  func handleFor(point: Point) -> Handle?
  var active: Bool { get set }
}


let GuideColor = (r: 0.6, g: 0.6, b: 0.6, a: 1.0)

typealias Color = (r: Double, g: Double, b: Double, a: Double)
