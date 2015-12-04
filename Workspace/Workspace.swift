/**
 The Workspace consists of the drawing, the active drawing, any guides that are 
 active, and any settings or state (like tool selection, etc)
*/

class Workspace<ImageType, IndexType: Hashable> {
  let activeDrawing = ActiveDrawing<ImageType, IndexType>()
  let drawing = Drawing<ImageType>()
  let guides = GuideCollection<IndexType>()
}