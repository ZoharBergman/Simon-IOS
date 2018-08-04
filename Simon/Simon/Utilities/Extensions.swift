//
//  Extensions.swift
//  Simon
//
//  Created by Zohar Bergman on 05/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instantiate(storyboardName: String? = nil) -> Self {
        return instantiateFromStoryboardHelper(storyboardName)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T: UIViewController>(_ storyboardName: String?) -> T {
        let storyboard = storyboardName != nil ? UIStoryboard(name: storyboardName!, bundle: nil) : UIStoryboard(name: "Main", bundle: nil)
        let identifier = NSStringFromClass(T.self).components(separatedBy: ".").last!
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
    
    func mostTopViewController() -> UIViewController {
        guard let topController = self.presentedViewController else { return self }
        
        return topController.mostTopViewController()
    }
}

extension UIApplication {
    static func mostTopViewController() -> UIViewController? {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        return topController.mostTopViewController()
    }
}

extension UIAlertController {
    
    /**
     Dismisses the current alert (if presented) and pops up the new one
     */
    @discardableResult
    func show() -> UIAlertController? {
        guard let mostTopViewController = UIApplication.mostTopViewController() else {
            "Failed to present alert [title: \(String(describing: self.title)), message: \(String(describing: self.message))]"; return nil }
        if mostTopViewController is UIAlertController { // Prevents a horrible bug, also promising the invocation of 'viewWillDisappear' in 'CommonViewController'
            // 1. Dismiss the alert
            mostTopViewController.dismiss(animated: true, completion: {
                // 2. Then present fullscreen
                UIApplication.mostTopViewController()?.present(self, animated: true, completion: nil)
            })
        } else {
            mostTopViewController.present(self, animated: true, completion: nil)
        }
        
        return self
    }
    
    func withAction(_ action: UIAlertAction) -> UIAlertController {
        self.addAction(action)
        return self
    }
    
    func withInputText(configurationBlock: @escaping ((_ textField: UITextField) -> Void)) -> UIAlertController {
        self.addTextField(configurationHandler: { (textField: UITextField!) -> () in
            configurationBlock(textField)
        })
        return self
    }
    
    static func makeAlert(title: String, message: String, dismissButtonTitle:String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        return alertController
    }
    
    /**
     A service method that alerts with title and message in the top view controller
     
     - parameter title: The title of the UIAlertView
     - parameter message: The message inside the UIAlertView
     */
    static func alert(title: String, message: String, dismissButtonTitle:String = "OK", onGone: (() -> Void)? = nil) {
        UIAlertController.makeAlert(title: title, message: message).withAction(UIAlertAction(title: dismissButtonTitle, style: UIAlertActionStyle.cancel, handler: { (alertAction) -> Void in
            onGone?()
        })).show()
    }
}
