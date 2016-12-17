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
  func handleFor(_ point: Point) -> Handle?
  func appliesToPoint(_ point: Point) -> Bool
  var transformation: StrokeTransformation { get }
  var active: Bool { get set }
}


let GuideEdges = Color(r: 0.7, g: 0.2, b: 0.2, a: 0.9)
let HandleEdges = Color(r: 0.7, g: 0.7, b: 0.7, a: 1.0)
let GuideFill = Color(r: 0.98, g: 0.98, b: 0.99, a: 0.75)
