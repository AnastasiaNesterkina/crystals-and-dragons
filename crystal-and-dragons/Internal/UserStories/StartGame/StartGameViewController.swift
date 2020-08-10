//
//  StartGameViewController.swift
//  crystal-and-dragons
//
//  Created by user177659 on 8/9/20.
//  Copyright © 2020 user177659. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController{
    
    @IBOutlet weak var nTextField: UITextField!
    @IBOutlet weak var mTextField: UITextField!
    
    @IBAction func didTapStartButton(_ sender: Any) {
        if let M = Int(mTextField.text ?? ""), let N = Int(nTextField.text ?? ""), M != 0, N != 0 {
            let identifier = Constants.StoryboardIDs.gameViewController
            let storyboard = UIStoryboard(name: identifier, bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
            
            if let gameViewController = viewController as? GameViewController {
                gameViewController.context = Context(M: M, N: N)
                
                let navigationController =
                    UINavigationController(rootViewController: gameViewController)
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
