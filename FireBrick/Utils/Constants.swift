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
    
    enum commonStrings {
        static let signUpButton = "SIGN UP"
        static let LogInButton = "LOG IN"
        static let eMailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let placeHolder = "ic_readable_icon_error.png"
    }
    
    enum errorCodes {
        static let googleUserCancel = -5
    }
    
    enum fireStoreFields {
        enum technology {
            static let name = "name"
            static let documentation = "documentation"
            static let icon = "icon"
            static let color = "color"
        }
        enum teams {
            static let name = "name"
            static let users = "users"
            static let documentID = ""
        }
        enum users {
            static let name = "name"
            static let icon = "icon"
        }
    }
    enum mainFireStoreCollections {
        static let technology = "Technology"
        static let teams = "Teams"
    }
    
    enum controllers {
        static let workspaceViewController = "WorkspaceViewController"
        static let technologyViewController = "TechnologyViewController"
        static let teamViewController = "TeamViewController"
        static let splashScreenViewController = "SplashScreenViewController"
        static let forgotPasswordViewController = "ForgotPasswordViewController"
        static let emailAuthViewController = "EmailAuthViewController"
        static let authViewController = "AuthViewController"
        static let addTechnologyViewController = "AddTechnologyViewController"
        static let simpleAlertViewController = "SimpleAlertViewController"
        static let chooseTechnologyViewController = "ChooseTechnologyViewController"
    }
    enum cellsID {
        static let technologyTableViewCell = "TechnologyTableViewCell"
        static let teamTableViewCell = "TeamTableViewCell"
        static let employeeTableViewCell = "EmployeeTableViewCell"
        static let chooseTableViewCell = "ChooseTableVeiwCell"
    }
}
