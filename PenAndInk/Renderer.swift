// A renderer is something that takes a 

protocol Renderer {
    func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double)
}

protocol ImageRenderer {
    typealias ImageType
    func line(ax: Double, _ ay: Double, _ bx: Double, _ by: Double)
    func image(image: ImageType)
}

