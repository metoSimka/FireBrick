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
    
    enum forAnimation {
        static let normal = 0.5
        static let fast = 0.2
    }
    
    enum strings {
        static let signUpButton = "SIGN UP"
        static let LogInButton = "LOG IN"
        static let eMailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    enum errorCodes {
        static let googleUserCancel = -5
    }
    
    enum fireStoreFields {
        enum technology {
            static let technologyNameField = "name"
            static let technologyDocumentationField = "documentation"
        }
    }
    enum mainFireStoreCollections {
        static let technology = "Technology"
    }
}
