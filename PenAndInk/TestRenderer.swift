//
//  TestRenderer.swift
//  PenAndInk
//
//  Created by Sam Bleckley on 11/17/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//

class TestRenderer : Renderer {
    var image :String = ""

    func line(ax: Double, ay: Double, bx: Double, by: Double) {
        image += "\nline(\(ax), \(ay), \(bx), \(by))"
    }
}
