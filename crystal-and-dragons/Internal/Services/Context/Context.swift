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
                self.rooms.append(Room(id: i * M + j))
                rooms.last?.generateDoors(M, N)
                rooms.last?.generateThings()
            }
        }
        
        // Connect unlinking doors in rooms
        // TO DO: try escape repeating operations
        for room in rooms {
            for i in 0...room.doors.count-1 {
                let door = room.doors[i]
                if door != -1 {
                    var id = room.id
                    switch i {
                    case 0: id -= 1
                    case 1: id += 1
                    case 2: id += M
                    case 3: id -= M
                    default: break
                    }
                    rooms[door].doors[id] = room.id
                }
            }
        }
        
        let playersRoom = Int.random(in: 0...M * N - 1)
        self.player = Player(idRoom: playersRoom)
    }
}
