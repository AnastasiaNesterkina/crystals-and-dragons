//
//  Thing.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/7/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import Foundation
enum Things {
    case key
    case box
    case stone
    case mushroom
    case bone
}

struct Thing {
    let name: Things
    var coordinate: Point
}
