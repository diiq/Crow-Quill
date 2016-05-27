struct Color {
  let r: Double
  let g: Double
  let b: Double
  let a: Double

  func with_opacity(a: Double) -> Color {
    return Color(r: r, g: g, b: b, a: a)
  }
}

let NonPhotoBlue = Color(r: 0.64, g: 0.86, b: 0.93, a: 1)