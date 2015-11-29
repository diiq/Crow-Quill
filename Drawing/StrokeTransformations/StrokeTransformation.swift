/**
 A StrokeTransformation is like a compiler pass; it applies some logic to a set
 of points, and returns a new set of points.

 Because the input and output types are the same, StrokeTransformations can be 
 chained.
*/
protocol StrokeTransformation {
  func apply(points: [StrokePoint]) -> [StrokePoint]
}


extension Array {
  func partition (n: Int, step maybeStep: Int? = nil, includeHead: Bool=false, includeTail: Bool=false) -> [Array] {
    var result = [Array]()

    // If no step is supplied move n each step.
    let step = maybeStep ?? n
    let end = includeTail ? count : count - n + 1
    let start = includeHead ? 1 - n : 0

    for var i = start; i < end; i += step { 
      result.append(Array(self[max(i, 0)..<min(count, i + n)]))
    }

    return result
  }

  func slidingWindow<T>(block: (focus: Element, before: Element?, after: Element?) -> T?) -> [T] {
    var result: [T] = []
    for var i = 0; i < count; i++ {
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



