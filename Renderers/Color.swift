struct Color {
  let r: Double
  let g: Double
  let b: Double
  let a: Double

  func with_opacity(a: Double) -> Color {
    return Color(r: r, g: g, b: b, a: a)
  }
}