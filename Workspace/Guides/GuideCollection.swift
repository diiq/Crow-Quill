class GuideCollection<IndexType: Hashable> {
  let guides: [Guide] = [RulerGuide()]
  var handleForIndex = [IndexType: Handle]()
  var transformationForIndex = [IndexType: StrokeTransformation]()

  var activeGuides: [Guide] {
    return guides.filter { return $0.active }
  }

  func draw(_ renderer: Renderer) {
    activeGuides.forEach { $0.draw(renderer) }
  }

  func pointInside(_ point: Point) -> Bool {
    return handleFor(point) != nil
  }

  func move(_ index: IndexType, point: Point) {
    guard let handle = handleForIndex[index] ?? savedHandleForIndex(index, point: point) else { return }
    handle.move(point)
  }

  func endMove(_ index: IndexType) {
    handleForIndex.removeValue(forKey: index)
  }

  func toggleActive() {
    // TODO this is silly if currently effective.
    guides.forEach {
      var guide = $0
      guide.active = !guide.active
    }
  }

  func setGuideTransformationForIndex(_ index: IndexType, point: Point) {
    for guide in activeGuides {
      if guide.appliesToPoint(point) {
        transformationForIndex[index] = guide.transformation
        return
      }
    }
  }

  fileprivate func handleFor(_ point: Point) -> Handle? {
    for guide in activeGuides {
      let handle = guide.handleFor(point)
      if handle != nil {
        return handle
      }
    }
    return nil
  }

  fileprivate func savedHandleForIndex(_ index: IndexType, point: Point) -> Handle? {
    guard let handle = handleFor(point) else { return nil }
    handleForIndex[index] = handle
    return handle
  }
}
