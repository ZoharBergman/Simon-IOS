//
//  GameOverController.swift
//  Simon
//
//  Created by Zohar Bergman on 03/08/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class GameOverController: UIViewController {
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnShareButton: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    let shareButton = FBSDKShareButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScore.text = "You got " + String(GameManager.sharedInstance.getLevel() - 1) + " points!"
        
        // Add Facebook share button
        view.addSubview(shareButton)
        shareButton.center = view.center
        assignPhotoToShareOnFacebook(image: GameManager.sharedInstance.getScreenShot())
    
        // Creating custom back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameOverController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        startSpinLogo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopSpinLogo()
    }
    
    @IBAction func onStartAgainButtonPressed(_ sender: UIButton) {
        GameManager.sharedInstance.initGame()
        navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func onShareButtonPressed(_ sender: UIButton) {
//        DispatchQueue.main.async {
//            var activityItems: [AnyObject]?
//
//            activityItems = ["I played on Simon" as AnyObject, GameManager.sharedInstance.getScreenShot()]
//
//            let activityController = UIActivityViewController(activityItems:
//                activityItems!, applicationActivities: nil)
//
//            activityController.popoverPresentationController?.sourceView = self.view
//
//            self.present(activityController, animated: true,
//                         completion: nil)
//        }
//    }
    
    func assignPhotoToShareOnFacebook(image : UIImage) {
        let fbSharePhoto = FBSDKSharePhoto()
        fbSharePhoto.image = image
        fbSharePhoto.caption = "I played on Simon!"
        
        let fbShareContent = FBSDKSharePhotoContent()
        fbShareContent.photos = [fbSharePhoto]
        
        shareButton.shareContent = fbShareContent
    }
    
    func startSpinLogo() {
        let spinning = CABasicAnimation(keyPath: "transform.rotation.z")
        spinning.fromValue = 0
        spinning.toValue = 2*3.14
        spinning.duration = 2.5
        spinning.repeatCount = .infinity
        
        imgLogo.layer.add(spinning, forKey: "spin")
    }
    
    func stopSpinLogo() {
        DispatchQueue.main.async() {    
            self.imgLogo.layer.removeAllAnimations()
        }
    }
}
