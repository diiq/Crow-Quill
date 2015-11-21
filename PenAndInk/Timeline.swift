/**
 A Timeline represents a series of actions which can be efficiently undone, redone,
 replayed, or jumped into.

 TODO: Something about serializing these suckers to disk.
 */

class Timeline<Event> {
  private var array: [Event] = []
  private var maxRedoIndex: Int = 0
  var currentIndex: Int = 0

  func canUndo() -> Bool {
    return currentIndex > 0
  }

  func canRedo() -> Bool {
    return currentIndex < maxRedoIndex
  }
  
  func undo() {
    guard canUndo() else { return }
    currentIndex -= 1
  }
  
  func redo() {
    guard canRedo() else { return }
    currentIndex += 1
  }
  
  func add(event: Event) {
    if array.count > currentIndex {
      array[currentIndex] = event
    } else {
      array.append(event)
    }
    
    currentIndex += 1
    modified()
  }
  
  func events(since start: Int) -> ArraySlice<Event> {
    guard currentIndex > start else {
      return ArraySlice<Event>([])
    }
    return array[start..<currentIndex]
  }
  
  func events() -> ArraySlice<Event> {
    return array[0..<currentIndex]
  }
  
  func latest() -> Event? {
    guard currentIndex != 0 else { return nil }
    return array[currentIndex - 1]
  }

  /**
   Call modified() whenever a timeline event occurs.

   It ensures that, if the event occurs after a series of undos, the now-obsolete events cannot be redone.

   Note: as things stand, those obsolete events will not be dereferenced until they're overwritten.
   */
  func modified() {
    maxRedoIndex = currentIndex
  }
}
