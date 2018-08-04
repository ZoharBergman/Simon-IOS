//
//  ViewController.swift
//  Simon
//
//  Created by Zohar Bergman on 03/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit
import Social

class MenuController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = "Zohar"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onGoButtonPressed(_ sender: UIButton) {
        txtName.text = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validating that the user entered a name
        if (txtName.text!.isEmpty) {
            UIAlertController.alert(title: "Error", message: "Please enter a name")
        } else {
            GameManager.sharedInstance.setPlayerName(playerName: txtName.text!)
            
            // Navigating to the game's view
            navigationController?.pushViewController(GameController.instantiate(), animated: true)
        }
    }
    
    @IBAction func onViewScoresPressed(_ sender: UIButton) {        
        // Navigating to the scores view
        let scoresController = ScoresController.instantiate()
        navigationController?.pushViewController(scoresController, animated: true)
    }        
}

