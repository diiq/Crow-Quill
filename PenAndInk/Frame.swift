

class Frame<I> : ImageDrawable {
    typealias ImageType = I
    let initialImage: ImageType
    var strokes: [Drawable] = []
    init(initialImage: ImageType) {
        self.initialImage = initialImage
    }
    
    func draw<R:ImageRenderer where R.ImageType == ImageType>(renderer: R) {
        renderer.image(self.initialImage)
    }
}