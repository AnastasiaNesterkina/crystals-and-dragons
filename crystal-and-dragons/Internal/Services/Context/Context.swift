//
//  Context.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/7/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import Foundation

class Context {
    let M, N: Int
    var rooms: [Room] = []
    let player: Player
    
    init(M: Int, N: Int) {
        self.M = M
        self.N = N
        
        for i in 0...N-1 {
            for j in 0...M-1 {
                self.rooms.append(Room(id: i*M+j, M:M, N:N))
            }
        }
        //TO DO: connect unlinking doors in rooms
        
        let playersRoom = Int.random(in: 0...M*N-1)
        self.player = Player(idRoom: playersRoom)
    }
}
