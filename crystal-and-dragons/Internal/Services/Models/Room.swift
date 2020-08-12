//
//  File.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/7/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import Foundation

class Room {
    let id: Int
    // array of adjoining rooms ids
    var doors: [Int] = [-1, -1, -1, -1]
    var things: [Thing] = []
    
    init(id: Int) {
        self.id = id
    }
    
    func generateDoors(_ M: Int, _ N: Int) -> [[Int]]{
        doors = [-1, -1, -1, -1]
        // Result of generateDoors is array of rooms in which some doors
        // must be installed: [[idRoom,idDoor], ...]
        var idChanges: [[Int]] = []
        // rooms count > 1
        if N > 1 && M > 1 {
            // determine in which direction the doors can be installed
            var exceptions: Set<Int> = []
            let i = id / M, j = id % M
            if j == 0 {
                exceptions.insert(0)
            }
            if j == M - 1 {
                exceptions.insert(1)
            }
            if i == 0 {
                exceptions.insert(3)
            }
            if i == N - 1 {
                exceptions.insert(2)
            }
            let sides: Set<Int> = [0, 1, 2, 3] // left, right, bottom, top
            let directions = sides.subtracting(exceptions)
            
            // Install the doors
            let doorsCount = Int.random(in: 1...directions.count)
            for _ in 0...doorsCount {
                let direction = directions.randomElement()
                switch direction {
                case 0:
                    doors[0] = id - 1
                    idChanges.append([id - 1, 1])
                case 1:
                    doors[1] = id + 1
                    idChanges.append([id + 1, 0])
                case 2:
                    doors[2] = id + M
                    idChanges.append([id + M, 3])
                case 3:
                    doors[3] = id - M
                    idChanges.append([id - M, 2])
                default:
                    break
                }
            }
        }
        return idChanges
    }
    
    func generateThings() {
        things = []
        // Add random things
        let countThings = Int.random(in: 0...4)
        let things = Set<Things>(Things.allCases)
            .subtracting(Set<Things>([.key, .box]))
            
        for i in 0..<countThings {
            if let thing = things.randomElement() {
                var coordinate = Point(x: 0, y: 0)
                switch i {
                case 1: coordinate = Point(x: 100, y: 0)
                case 2: coordinate = Point(x: 0, y: 100)
                case 3: coordinate = Point(x: 100, y: 100)
                default:
                    break
                }
                self.things.append(Thing(name: thing,
                                         coordinate: coordinate))
            }
        }
    }
}
