//
//  TestRendererTests.swift
//  PenAndInk
//
//  Created by Sam Bleckley on 11/17/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//

import XCTest
@testable import PenAndInk

class TestRendererTests: XCTestCase {

    func testDrawsAStraightLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let renderer = TestRenderer()
        renderer.line(10, 50, 20, 30)

        XCTAssertEqual(renderer.image, ["line: 10.0, 50.0, 20.0, 30.0"],
            "Calling line adds a single string")
    }
}
