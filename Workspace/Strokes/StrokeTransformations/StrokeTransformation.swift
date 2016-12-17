/**
 A StrokeTransformation is like a compiler pass; it applies some logic to a set
 of points, and returns a new set of points.

 Because the input and output types are the same, StrokeTransformations can be 
 chained.
*/
protocol StrokeTransformation {
  func apply(_ points: [Point]) -> [Point]
}

extension Array {
  func partition (_ n: Int, step maybeStep: Int? = nil, includeHead: Bool=false, includeTail: Bool=false) -> [Array] {
    var result = [Array]()

    // If no step is supplied move n each step.
    let step = maybeStep ?? n
    let end = includeTail ? count : count - n + 1
    let start = includeHead ? 1 - n : 0

    for i in stride(from: start, to: end, by: step) {
      result.append(Array(self[[i, 0].max()!..<[count, i + n].min()!]))
    }

    return result
  }

  func slidingWindow<T>(_ block: (_ focus: Element, _ before: Element?, _ after: Element?) -> T?) -> [T] {
    var result: [T] = []
    for i in 0 ..< count {
      let ret = block(self[i], self[safe: i - 1], self[safe: i + 1])
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



