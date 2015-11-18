//
//  Drawable.swift
//  PenAndInk
//
//  Created by Sam Bleckley on 11/17/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//

protocol Drawable {
    /// draw() issues drawing commands to `renderer` to visually represent `self`.
    func draw(renderer: Renderer)
}

