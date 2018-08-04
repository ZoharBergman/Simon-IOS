//
//  Constants.swift
//  Simon
//
//  Created by Zohar Bergman on 09/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit

class Constants {
    enum eSimonButton : Int {
        case notSet = -1
        case topLeft, topRight, bottomLeft, bottomRight
        
        static func getNumberOfSimonButtons() -> Int {
            return 4
        }
    }
}
