//: ## Strokes
//:
//: Strokes represent individual stokes of a stylus in the drawing. Each stroke type has a specific
//: way of rendering itself. Note that the strokepoint position and weight do NOT necessarily
//: correspond to specific UITouch points.


//: A FixedPenStroke is a specific kind of stroke -- it has no variation in width; it's just a line.
struct FixedPenStroke : Drawable {
    let points: [StrokePoint]
    let brush_size: Double = 1

    func draw(renderer: Renderer) {
        var last_point = points[0]
        points[1..<points.count].forEach {
            renderer.line(last_point.x, last_point.y, $0.x, $0.y)
            last_point = $0
        }
    }
}
