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
        
        // Generate rooms
        for i in 0...N-1 {
            for j in 0...M-1 {
                self.rooms.append(Room(id: i * M + j))
                rooms.last?.generateThings()
            }
        }
        
        // Generate doors and connect unlinking doors in rooms
        for room in rooms {
            // Result of generation is array of rooms in which some doors
            // must be installed: [[idRoom,idDoor], ...]
            let idChanges = room.generateDoors(M, N)
            for elem in idChanges {
                    rooms[elem[0]].doors[elem[1]] = room.id
            }
        }
        
        let playersRoom = Int.random(in: 0...M * N - 1)
        self.player = Player(idRoom: playersRoom)
        
        //TO DO: find the place for key and box; calculate steps
    }
}
