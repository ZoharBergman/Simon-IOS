//
//  GameController.swift
//  Simon
//
//  Created by Zohar Bergman on 05/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit
import AVFoundation

class GameController: UIViewController {
    @IBOutlet weak var btnTopLeft: SimonButton!
    @IBOutlet weak var btnTopRight: SimonButton!
    @IBOutlet weak var btnBottomRight: SimonButton!
    @IBOutlet weak var btnBottomLeft: SimonButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCountdown: UILabel!
    
    var countdown = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCountdown.isHidden = true
        initBoard()
        GameManager.sharedInstance.attachBoardComponents(topLeft: btnTopLeft, topRight: btnTopRight, bottomLeft: btnBottomLeft, bottomRight: btnBottomRight, lblLevel: lblLevel, lblState: lblState)
        GameManager.sharedInstance.initGame()
        
        // Creating custom back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Create an alert message to validate that the player is sure about going back
        UIAlertController.makeAlert(title: "", message: "Are you sure?").withAction(
            UIAlertAction(title: "Yes", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
                
            // Go back to the menu
            self?.navigationController!.popViewController(animated: true)
        })).withAction(
            UIAlertAction(title: "No", style: .default, handler: {
                [weak self] (alert: UIAlertAction) -> Void in
                // Dismissing the alert
                self?.dismiss(animated: true, completion: nil)
            }))
            .show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCountDown()
    }
    
    func initBoard() {
        // Setting the properties of the simon buttons
        btnTopRight.setButtonSettings(buttonId: Constants.eSimonButton.topRight, soundResource: "simonSound1", corners: [.topRight], cornerRadii: CGSize(width: 40, height: 40))
        btnTopLeft.setButtonSettings(buttonId: Constants.eSimonButton.topLeft, soundResource: "simonSound2", corners: [.topLeft], cornerRadii: CGSize(width: 40, height: 40))
        btnBottomRight.setButtonSettings(buttonId: Constants.eSimonButton.bottomRight, soundResource: "simonSound3", corners: [.bottomRight], cornerRadii: CGSize(width: 40, height: 40))
        btnBottomLeft.setButtonSettings(buttonId: Constants.eSimonButton.bottomLeft, soundResource: "simonSound4", corners: [.bottomLeft], cornerRadii: CGSize(width: 40, height: 40))
        
        // Setting the labels of the player name and the level
        lblName.text = GameManager.sharedInstance.getPlayerName()
    }
    
    func onFinishGame() {
      // Navigating to the game over's view
      navigationController?.pushViewController(GameOverController.instantiate(), animated: true)
    }
    
    @IBAction func onSimonButtonPressed(_ sender: Any) {
        guard let button = sender as? SimonButton else {
            return
        }
        
        UIView.transition(with: button,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            button.playSound()
                            button.backgroundColor =                          button.backgroundColor?.withAlphaComponent(0.4)
        },
                          completion: {(_ : Bool) -> Void in
                            UIView.transition(with: button,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {
                                                button.backgroundColor =                          button.backgroundColor?.withAlphaComponent(1)
                            },
                                              completion: {(_ : Bool) -> Void in
                                                GameManager.sharedInstance.checkSimonButtonPress(simonButton: button, finishGameHandler: self.onFinishGame)}
                            )
        })
    }
    
    func startCountDown() {
        lblCountdown.isHidden = false
        countDown()
    }
    
    func countDown() {
        UIView.transition(with: lblCountdown, duration: 1, options: .transitionCrossDissolve, animations: {[weak self] in
            self?.lblCountdown.text = String(describing: self?.countdown)
        }, completion: onCompleteCountdown)
    }
    
    func onCompleteCountdown(_ : Bool) -> Void {
        countdown -= 1
        
        if (countdown > 0) {
            countDown()
        } else {
            finishCountDown()
        }
    }
    
    func finishCountDown() {
        UIView.transition(with: lblCountdown, duration: 1, options: .transitionCrossDissolve, animations: {[weak self] in
            self?.lblCountdown.text = "GO"
            }, completion: {[weak self] (_ : Bool) -> Void in
                self?.lblCountdown.isHidden = true
                GameManager.sharedInstance.startShowLevel()
        })
    }
}

