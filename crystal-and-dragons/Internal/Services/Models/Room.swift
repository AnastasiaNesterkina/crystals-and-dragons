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
    
    init(id: Int, M: Int, N: Int) {
        self.id = id
        
        // rooms count > 1
        if N > 1 && M > 1 {
            // determine in which direction the doors can be installed
            var exceptions: Set<Int> = []
            let i = id/M, j = id%M
            if j == 0 {
                exceptions.insert(0)
            }
            if j == M-1 {
                exceptions.insert(1)
            }
            if i == 0 {
                exceptions.insert(3)
            }
            if i == N-1 {
                exceptions.insert(2)
            }
            let sides: Set<Int> = [0, 1, 2, 3] //left, right, bottom, top
            let directions = Array<Int>(sides.subtracting(exceptions))
            
            // install the doors
            let doorsCount = Int.random(in: 1...directions.count)
            for _ in 0...doorsCount {
                let idSide = Int.random(in: 0...directions.count-1)
                let direction = directions[idSide]
                switch direction {
                case 0:
                    doors[0] = id-1
                case 1:
                    doors[1] = id+1
                case 2:
                    doors[2] = id-M
                case 3:
                    doors[3] = id+M
                default:
                    break
                }
            }
            
            //TO DO: Add random things
        }
    }
}
