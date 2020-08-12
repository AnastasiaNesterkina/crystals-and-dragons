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
    @IBOutlet weak var inventoryCollectionView: UICollectionView!
    
    @IBOutlet weak private var topButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var bottomButton: UIButton!
    
    var context: Context?
    private var selectedThing: Thing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageCellNib = UINib(nibName: Constants.NibNames.imageCellNib,
                                 bundle: nil)
        inventoryCollectionView.delegate = self
        inventoryCollectionView.dataSource = self
        inventoryCollectionView
            .register(imageCellNib,
                      forCellWithReuseIdentifier: Constants.CellReuseIdentifiers.imageCell)
        
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
        guard let thing = selectedThing else { return }
        if thing.name == Things.key {
            for view in roomView.subviews {
                if let image = view as? ImageCell,
                    image.thing?.name == Things.box,
                    let thing = image.thing {
                    roomView.addSubview(UIImageView(image: UIImage(named:
                        Constants.PicturesNames.IconNames.openedBox)))
                    roomView.subviews.last?
                        .frame = CGRect(x: thing.coordinate.x,
                                        y: thing.coordinate.y,
                                        width: 50,
                                        height: 50)
                    view.removeFromSuperview()
                    selectedThing = nil
                    
                    let alert = UIAlertController(
                        title: "Congrats!",
                        message: "You are winner!",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                    break
                }                
            }
        }
    }
    
    @IBAction func didTapDropButton(_ sender: Any) {
        guard let thing = selectedThing, let context = context else {
            return
        }
        let image = ImageCell()
        image.setupImage(thing, width: roomView.frame.width,
                         height: roomView.frame.height)
        roomView.addSubview(image)
        roomView.subviews.last?.frame = CGRect(x: thing.coordinate.x,
                                               y: thing.coordinate.y,
                                               width: 50,
                                               height: 50)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self
                                                .didTapImage(_:)))
        roomView.subviews.last?.addGestureRecognizer(tap)
        roomView.subviews.last?.isUserInteractionEnabled = true
        context.rooms[context.player.idRoom].things.append(thing)
        let inventory = context.player.inventory
        for i in 0..<inventory.count {
            if inventory[i] == thing {
                context.player.inventory.remove(at: i)
                inventoryCollectionView.reloadData()
                selectedThing = nil
                break
            }
        }
    }
    
    @IBAction func DidTapDiscardButton(_ sender: Any) {
        guard let thing = selectedThing, let context = context,
            thing.name != Things.key else { return }
        let inventory = context.player.inventory
        for i in 0..<inventory.count {
            if inventory[i] == thing {
                context.player.inventory.remove(at: i)
                inventoryCollectionView.reloadData()
                selectedThing = nil
                break
            }
        }
    }
}

// MARK: - Draw room
private extension GameViewController {
    func nextDoor(_ direction: Int) {
        guard let context = context, context.player.steps != 0 else {
            return
        }
        
        let idRoom = context.player.idRoom
        context.player.idRoom = context.rooms[idRoom].doors[direction]
        context.player.steps -= 1
        draw()
        
        if context.player.steps == 0 && (!isRoomThing(Things.box) || !(isRoomThing(.key) || isInventoryThing(.key))){
            let alert = UIAlertController(
                title: "I'm sorry...",
                message: "You lose... But you can try again!",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
    }
    
    func draw() {
        guard let context = context else { return }
        stepsLeft.text = "Steps left: " + String(context.player.steps)
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
            let image = ImageCell()
            image.setupImage(thing, width: roomView.frame.width,
                             height: roomView.frame.height)
            roomView.addSubview(image)
            roomView.subviews.last?.frame = CGRect(x: thing.coordinate.x,
                                                   y: thing.coordinate.y,
                                                   width: 50,
                                                   height: 50)
            if(thing.name != Things.box) {
                let tap = UITapGestureRecognizer(target: self,
                                                 action: #selector(self
                                                    .didTapImage(_:)))
                roomView.subviews.last?.addGestureRecognizer(tap)
                roomView.subviews.last?.isUserInteractionEnabled = true
            }
            
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

// MARK: - Tap Image
private extension GameViewController {
   @objc func didTapImage(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        guard let context = context else { return }
        if roomView.subviews.contains(view) {
            if let image = view as? ImageCell, let thing = image.thing,
                context.player.inventory.count < 5 {
                context.player.inventory.append(thing)
                let id = context.player.idRoom
                let things = context.rooms[id].things
                for i in 0..<things.count {
                    if thing == things[i] {
                        context.rooms[id].things.remove(at: i)
                        break
                    }
                }
                view.removeFromSuperview()
                inventoryCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Collection Delegate
extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let context = context else { return }
        selectedThing = context.player.inventory[indexPath.row]
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let context = context else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIdentifiers.imageCell, for: indexPath) as? ImageCell else {
                       return UICollectionViewCell()
        }
        cell.setupImage(context.player.inventory[indexPath.row],
                        width: roomView.frame.width,
                        height: roomView.frame.height)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let context = context else { return 0 }
        return context.player.inventory.count
    }
    
}

// MARK: - Thing belonging func
private extension GameViewController {
    func isRoomThing(_ thing: Things) -> Bool {
        for view in roomView.subviews {
            if let image = view as? ImageCell,
                image.thing?.name == thing {
                return true
            }
        }
        return false
    }
    
    func isInventoryThing(_ thing: Things) -> Bool {
        guard let inventory = context?.player.inventory else { return false }
        for elem in inventory {
            if elem.name == thing {
                return true
            }
        }
        return false
    }
}
