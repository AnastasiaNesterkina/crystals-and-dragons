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
        
        let playerRoom = Int.random(in: 0...M * N - 1)
        self.player = Player(idRoom: playerRoom)
        
        // Player can go to these rooms
        var playerRooms: [Int] = [playerRoom]
        for room in playerRooms {
            for door in rooms[room].doors {
                if door != -1 && !playerRooms.contains(door) {
                    playerRooms.append(room)
                }
            }
        }
        
        // Find the place for key and box
        let idBoxRoom = playerRooms[Int.random(in: 0..<playerRooms.count)]
        let idKeyRoom = playerRooms[Int.random(in: 0..<playerRooms.count)]
        rooms[idBoxRoom].things.append(Thing(name: .box,
                                             coordinate: Point(x: 50, y: 50)))
        rooms[idKeyRoom].things.append(Thing(name: .key,
                                             coordinate: Point(x: 50, y: 50)))
        
        // Calculate steps
        self.player.steps = Context.breadthFirstSearch(idStart: playerRoom,
                                                       idEnd: idKeyRoom,
                                                       rooms: self.rooms)
        self.player.steps += Context.breadthFirstSearch(idStart: idKeyRoom,
                                                        idEnd: idBoxRoom,
                                                        rooms: self.rooms)
    }
    
    static private func breadthFirstSearch(idStart:Int, idEnd: Int, rooms: [Room])-> Int {
        var queue = [idStart]
        var visitedRooms: Set<Int> = [idStart]
        var parent: [Int: Int] = [idStart: idStart]
        
        while let visitedRoom = queue.first {
            queue.removeFirst()
            
            if visitedRoom == idEnd {
                break
            }
            for door in rooms[visitedRoom].doors {
                if !visitedRooms.contains(door) {
                    queue.append(door)
                    visitedRooms.insert(door)
                    parent[door] = visitedRoom
                }
            }
        }
        
        var room = idEnd
        var lengthWay = 0
        while room != idStart {
            guard let parent = parent[room] else {
                return -1
            }
            room = parent
            lengthWay += 1
        }
        
        return lengthWay
    }
}


