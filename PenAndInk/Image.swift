//
//  Image.swift
//  PenAndInk
//
//  Created by Sam Bleckley on 11/17/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//


// A Frame is a snapshot of the drawing plus a set of <N additional strokes to be drawn on to of that snapshot.
// Keeping those strokes separately makes it easy to undo and redo them.

class Image : Drawable {
    var frames: [Frame] = []
    func draw(renderer: Renderer) {
    }
}

