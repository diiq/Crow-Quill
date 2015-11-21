/**
 A Renderer is something that gets handed to a drawable and produces an image.

 That image can be any type at all; for tests our 'images' are arrays of strings.
 This protocol is a complete listing of all drawing methods necessary to render 
 an image. These should remain backwards-compatible, so that existing images can 
 still be opened and re-rendered.

 Be sure to check out [the WWDC talk](https://developer.apple.com/videos/play/wwdc2015-408/)
 that inspired this rendering architecture.
 */
protocol Renderer {
  /// Draws a straight, unweighted, black line from <ax, ay> to <bx, by>
  func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double)
}

/**
 An ImageRenderer is a Renderer that can inser previously rendered images of its
 ImageType into the image its currently rendering. This is used for recording 
 and displaying snapshots of the drawing, purely for performance reasons.
 */
protocol ImageRenderer: Renderer {
  typealias ImageType

  /// The rendered image
  var currentImage: ImageType { get }

  /// Places an existing image into the image being rendered.
  func image(image: ImageType)
}

