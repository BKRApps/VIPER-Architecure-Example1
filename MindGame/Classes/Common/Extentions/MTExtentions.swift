//
//  MTExtentions.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation

extension Int {
    static func randomIntFrom(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}
