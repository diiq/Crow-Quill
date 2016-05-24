/**
 A StrokeTransformation is like a compiler pass; it applies some logic to a set
 of points, and returns a new set of points.

 Because the input and output types are the same, StrokeTransformations can be 
 chained.
*/
protocol StrokeTransformation {
  func apply(points: [Point]) -> [Point]
}

extension Array {
  func slidingWindow<T>(block: (focus: Element, before: Element?, after: Element?) -> T?) -> [T] {
    var result: [T] = []
    for i in 0 ..< count {
      let ret = block(focus: self[i], before: self[safe: i - 1], after: self[safe: i + 1])
      if ret != nil {
        result.append(ret!)
      }
    }
    return result
  }

  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}



