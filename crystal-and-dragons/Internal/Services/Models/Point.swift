//
//  Coordinate.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/7/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import Foundation

struct Point {
    var x,y: Int
}

extension Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        if lhs.x == rhs.x && lhs.y == rhs.y {
            return true
        }
        return false
    }
    
}
