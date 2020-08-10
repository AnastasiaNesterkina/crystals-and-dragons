//
//  GameViewController.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/9/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak private var stepsLeft: UILabel!
    @IBOutlet weak private var roomView: UIView!
    
    @IBOutlet weak private var topButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var bottomButton: UIButton!
    
    var context: Context?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let steps = context?.player.steps {
            stepsLeft.text = "Steps left: " + String(steps)
        }
        draw()
    }
    
    // 0 - left, 1 - right, 2 - bottom, 3 - top
    @IBAction func didTapUpButton(_ sender: Any) {
        nextDoor(3)
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        nextDoor(1)
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        nextDoor(0)
    }
    
    @IBAction func didTapBottomButton(_ sender: Any) {
        nextDoor(2)
    }
    
    @IBAction func didTapUseButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapDropButton(_ sender: Any) {
        
    }
    
    @IBAction func DidTapDiscardButton(_ sender: Any) {
        
    }
}

private extension GameViewController {
    func nextDoor(_ direction: Int) {
        guard let context = context else { return }
        let idRoom = context.player.idRoom
        context.player.idRoom = context.rooms[idRoom].doors[direction]
        draw()
    }
    
    func draw() {
        drawDoors()
        drawThings()
    }
    
    func drawThings() {
        guard let context = context else { return }
        let idRoom = context.player.idRoom
        let things = context.rooms[idRoom].things
        
        // Clear current room
        for view in roomView.subviews {
            view.removeFromSuperview()
        }
        
        // Insert things to the room
        for thing in things {
            let image: UIImageView?
            
            switch thing.name {
            case Things.key:
                image = UIImageView(image: UIImage(named: Constants
                    .PicturesNames.IconNames.key))
            case Things.box:
                image = UIImageView(image: UIImage(named: Constants
                    .PicturesNames.IconNames.closedBox))
            case Things.bone:
                image = UIImageView(image: UIImage(named: Constants
                    .PicturesNames.IconNames.bone))
            case Things.mushroom:
                image = UIImageView(image: UIImage(named: Constants
                    .PicturesNames.IconNames.mushroom))
            case Things.stone:
                image = UIImageView(image: UIImage(named: Constants
                    .PicturesNames.IconNames.stone))
            }
            
            guard let img = image else {
                break
            }
            
            roomView.addSubview(img)
            roomView.subviews.last?.frame = CGRect(x: thing.coordinate.x,
                                                   y: thing.coordinate.y,
                                                   width: 50,
                                                   height: 50)
        }
    }
    
    func drawDoors() {
        guard let context = context else { return }
        let idRoom = context.player.idRoom
        let doors = context.rooms[idRoom].doors
        
        for i in 0 ..< doors.count {
            switch i {
            case 0:
                if doors[i] == -1 {
                    leftButton.isEnabled = false
                } else {
                    leftButton.isEnabled = true
                }
            case 1:
                if doors[i] == -1 {
                    rightButton.isEnabled = false
                } else {
                    rightButton.isEnabled = true
                }
            case 2:
                if doors[i] == -1 {
                    bottomButton.isEnabled = false
                } else {
                    bottomButton.isEnabled = true
                    
                }
            case 3:
                if doors[i] == -1 {
                    topButton.isEnabled = false
                } else {
                    topButton.isEnabled = true
                }
            default:
                break
            }
        }
    }
}
