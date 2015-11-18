// An image is a series of frames -- but it's drawn as just it's most recent frame.

class Drawing<I> : ImageDrawable {
    typealias ImageType = I
    var frames: [Frame<ImageType>] = []
    
    func draw<R:ImageRenderer where R.ImageType == ImageType>(renderer: R) {
        if let last_frame = frames.last {
            last_frame.draw(renderer)
        }
    }
}

