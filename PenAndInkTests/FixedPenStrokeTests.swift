//
//  FixedPenStrokeTests.swift
//  PenAndInk
//
//  Created by Sam Bleckley on 11/17/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//


import XCTest
@testable import PenAndInk

class FixedPenStrokeTests: XCTestCase {

    func testDrawsAStraightLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let points = (1...5).map {
            return StrokePoint(x: 10.0 * Double($0), y: 50.0, weight: 1)
        }

        let stroke = FixedPenStroke(points: points)

        let renderer = TestRenderer()
        stroke.draw(renderer)
        XCTAssert(renderer.image == "\nline(10.0, 50.0, 20.0, 50.0)\nline(20.0, 50.0, 30.0, 50.0)\nline(30.0, 50.0, 40.0, 50.0)\nline(40.0, 50.0, 50.0, 50.0)",
            "FixedPenStroke draws a straight line")
    }
}
