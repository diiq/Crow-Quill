// This 'renders' images into an array of strings that are easy to test

class TestRenderer : Renderer, ImageRenderer {
    typealias ImageType = [String]
    var image :ImageType = []

    func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double) {
        image.append("line: \(ax), \(ay), \(bx), \(by)")
    }
    
    func image(image: ImageType) {
        self.image.appendContentsOf(image)
    }
}
