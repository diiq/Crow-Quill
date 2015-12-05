class GuideCollection<IndexType: Hashable> {
  let guides: [Guide] = [RulerGuide()]
  var handleForIndex = [IndexType: Handle]()
  var activeGuides: [Guide] {
    return guides.filter { return $0.active }
  }

  func draw(renderer: Renderer) {
    activeGuides.forEach { $0.draw(renderer) }
  }

  func pointInside(point: Point) -> Bool {
    return handleFor(point) != nil
  }

  func startMove(point: Point, index: IndexType) {
    guard let handle = handleFor(point) else { return }
    handleForIndex[index] = handle
    handle.move(point)
  }

  func continueMove(point: Point, index: IndexType) {
    guard let handle = handleForIndex[index] else { return }
    handle.move(point)
  }

  func endMove(point: Point, index: IndexType) {
    guard let handle = handleForIndex[index] else { return }
    handle.move(point)
    handleForIndex.removeValueForKey(index)
  }

  private func handleFor(point: Point) -> Handle? {
    for guide in activeGuides {
      let handle = guide.handleFor(point)
      if handle != nil {
        return handle
      }
    }
    return nil
  }
}