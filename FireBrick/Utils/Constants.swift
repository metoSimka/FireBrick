//
//  Constants.swift
//  FireBrick
//
//  Created by metoSimka on 21/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    enum forConstraints {
        static let showValue: CGFloat = -17
        static let hideValue: CGFloat = 20
    }
    
    enum forAnimation {
        static let normal = 0.5
        static let fast = 0.2
    }
    
    enum strings {
        static let signUpButton = "SIGN UP"
        static let LogInButton = "LOG IN"
        static let eMailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    enum magicNumbers {
        static let minCountPasswordChars = 6
        static let halfAlpha: CGFloat = 0.5
        static let fullAlpha: CGFloat = 1
        static let zeroAlpha: CGFloat = 0
    }
    enum errorCodes {
        static let googleUserCancel = -5
    }
}
