class GuideCollection<IndexType: Hashable> {
  let guides = [RulerGuide()]
  var handleForTouch = [IndexType: Handle]()
  var active: [Guide] {
    return guides.filter { return $0.active }
  }
  
  
}