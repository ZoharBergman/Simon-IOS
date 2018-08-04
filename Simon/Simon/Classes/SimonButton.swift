//
//  SimonButton.swift
//  Simon
//
//  Created by Zohar Bergman on 09/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit
import AVFoundation

class SimonButton : UIButton {
    private var soundResource = ""
    private var eButtonId = Constants.eSimonButton.notSet
    private var audioPlayer : AVAudioPlayer!
    
    func setSoundResource (soundResource : String) {
        self.soundResource = soundResource
    }
    
    func getSoundResource () -> String {
        return soundResource
    }
    
    func setButtonId (buttonId : Constants.eSimonButton) {
        self.eButtonId = buttonId
    }
    
    func getButtonId () -> Constants.eSimonButton {
        return eButtonId
    }
    
    func roundCorners(corners : UIRectCorner, cornerRadii : CGSize) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: soundResource, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setButtonSettings(buttonId: Constants.eSimonButton, soundResource : String, corners : UIRectCorner, cornerRadii : CGSize) {
        setButtonId(buttonId: buttonId)
        setSoundResource(soundResource: soundResource)
        roundCorners(corners: corners, cornerRadii: cornerRadii)
    }
}
