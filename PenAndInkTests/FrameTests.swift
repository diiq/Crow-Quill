import XCTest
@testable import PenAndInk

class FrameTests: XCTestCase {
    
    func testDrawsInitialImage() {
        let renderer = TestRenderer()
        let frame = Frame<[String]>(initialImage: ["initial image"])

        frame.draw(renderer)
        
        XCTAssertEqual(renderer.image, [
            "initial image"],
            "FixedPenStroke draws a straight line")
    }
}
