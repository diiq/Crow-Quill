/*
 * An undo array is an array of actions which can efficiently be undone, redone, replayed, or jumped into.
 */

class UndoArray<Element> {
  typealias ElementType = Element
  private var array: Array<Element> = []
  private var maxRedoIndex: Int = 0
  var currentIndex: Int = 0
  
  func canUndo() -> Bool {
    return currentIndex > 0
  }
  
  func canRedo() -> Bool {
    return currentIndex < maxRedoIndex
  }
  
  func undo() {
    guard canUndo() else {
      return
    }
    
    currentIndex -= 1
  }
  
  func redo() {
    guard canRedo() else {
      return
    }
    
    currentIndex += 1
  }
  
  func add(element: Element) {
    if array.count > currentIndex {
      array[currentIndex] = element
    } else {
      array.append(element)
    }
    
    currentIndex += 1
    modified()
  }
  
  func actions(since start: Int) -> ArraySlice<Element> {
    guard currentIndex > start else {
      return ArraySlice<Element>([])
    }
    return array[start..<currentIndex]
  }
  
  func actions() -> ArraySlice<Element> {
    return array[0..<currentIndex]
  }
  
  func latestAction() -> Element? {
    guard currentIndex != 0 else {
      return nil
    }
    return array[currentIndex - 1]
  }
  
  func modified() {
    maxRedoIndex = currentIndex
  }
}
