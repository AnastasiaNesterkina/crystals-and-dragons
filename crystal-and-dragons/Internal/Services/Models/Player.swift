//
//  Player.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/7/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import Foundation

class Player {
    var idRoom: Int
    var steps = 100
    var inventory: [Thing] = []
    
    init(idRoom: Int) {
        self.idRoom = idRoom
    }
}
