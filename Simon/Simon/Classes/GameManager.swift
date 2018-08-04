//
//  GameManager.swift
//  Simon
//
//  Created by Zohar Bergman on 09/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//
import Foundation
import UIKit

class GameManager {
    // Static instance of the class
    static let sharedInstance = GameManager()
    
    // Properties
    private var playerName = ""
    private var level = 1
    private var arrButtonsOrder = [Constants.eSimonButton]()
    private var currentButtonPress = 0
    private var dicButtons : [Constants.eSimonButton : SimonButton] = [:]
    private var lblLevel : UILabel!
    private var lblState : UILabel!
    private var imgScreenShot = #imageLiteral(resourceName: "Logo")
    
    // Getters & Setters
    func getPlayerName () -> String {
        return playerName
    }
    
    func getLevel () -> Int {
        return level
    }
    
    func getArrButtonsOrder () -> [Constants.eSimonButton] {
        return arrButtonsOrder
    }
    
    func getCurrentButtonPress () -> Int {
        return currentButtonPress
    }
    
    func setPlayerName(playerName : String) {
        self.playerName = playerName
    }
    
    func setDicButtons(topLeft : SimonButton, topRight : SimonButton, bottomLeft : SimonButton, bottomRight : SimonButton) {
        // Clear dictionary
        dicButtons.removeAll(keepingCapacity: true)
        
        // Add the buttons
        dicButtons[topLeft.getButtonId()] = topLeft
        dicButtons[topRight.getButtonId()] = topRight
        dicButtons[bottomRight.getButtonId()] = bottomRight
        dicButtons[bottomLeft.getButtonId()] = bottomLeft
    }
    
    func getScreenShot() -> UIImage {
        return self.imgScreenShot
    }
    
    // Ctor
    private init() {}
    
    // Functions
    func getRandButton() -> Constants.eSimonButton {
        return Constants.eSimonButton(rawValue: Int(arc4random_uniform(UInt32(Constants.eSimonButton.getNumberOfSimonButtons()))))!
    }
    
    func attachBoardComponents(topLeft : SimonButton, topRight : SimonButton, bottomLeft : SimonButton, bottomRight : SimonButton, lblLevel : UILabel, lblState: UILabel) {
        self.lblLevel = lblLevel
        self.lblState = lblState
        setDicButtons(topLeft : topLeft, topRight : topRight, bottomLeft : bottomLeft, bottomRight : bottomRight)
    }
    
    func initGame() {
        level = 1
        currentButtonPress = 0
        self.arrButtonsOrder = []
        self.arrButtonsOrder.append(self.getRandButton())
        setLevelText()
        self.lblState.text = "Watch"
    }
    
    func setLevelText() {
        lblLevel.text = "Level: " + String(level)
    }
    
    func setStateText() {
        if (lblState.text == "Watch") {
            lblState.text = "Repeat"
        } else {
            lblState.text = "Watch"
        }
    }
    
    func startShowLevel() {
        setButtonsEnabled(isEnabled: false)
        startShowNextButton()
    }
    
    func startShowNextButton() {
        UIView.transition(with: dicButtons[arrButtonsOrder[currentButtonPress]]!,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.dicButtons[self.arrButtonsOrder[self.currentButtonPress]]?.playSound()
                            self.dicButtons[self.arrButtonsOrder[self.currentButtonPress]]?.backgroundColor =                          self.dicButtons[self.arrButtonsOrder[self.currentButtonPress]]?.backgroundColor?.withAlphaComponent(0.4)
        },
                          completion: finishShowNextButton)
    }
    
    func finishShowNextButton(_ : Bool) {
        UIView.transition(with: dicButtons[arrButtonsOrder[currentButtonPress]]!,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.dicButtons[self.arrButtonsOrder[self.currentButtonPress]]?.backgroundColor =                          self.dicButtons[self.arrButtonsOrder[self.currentButtonPress]]?.backgroundColor?.withAlphaComponent(1)
        },
                          completion: afterButtonShown)
    }
    
    func afterButtonShown(_ : Bool) {
        currentButtonPress += 1
        if (currentButtonPress == arrButtonsOrder.count) {
            setButtonsEnabled(isEnabled: true)
            currentButtonPress = 0
            setStateText()
        } else {
            startShowNextButton()
        }
    }
    
    func setButtonsEnabled(isEnabled : Bool) {
        dicButtons.values.forEach({currButton -> Void in
            currButton.isUserInteractionEnabled = isEnabled
        })
    }
    
    func checkSimonButtonPress(simonButton : SimonButton, finishGameHandler: () -> Void) {
        // Checking that the user pressed correctly
        if (arrButtonsOrder[currentButtonPress] == simonButton.getButtonId()) {
            // Checking if it was the last press for this level
            if (currentButtonPress + 1 == level) {
                // Going to next level
                level += 1
                setLevelText()
                setStateText()
                currentButtonPress = 0
                arrButtonsOrder.append(self.getRandButton())
                startShowLevel()                
            } else {
                currentButtonPress += 1
            }
        } else {
            // Take a screen shot
            self.imgScreenShot = captureScreenshot()
            
            // Save score
            Score.saveScore(name: playerName, points: level - 1)
            
            finishGameHandler()
        }
    }
    
    func captureScreenshot() -> UIImage{
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
}

