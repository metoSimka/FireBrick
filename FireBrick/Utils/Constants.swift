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
        static let nameFormat = "[A-Za-z]"
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
            static let hrs_in_week = "hrs_in_week"
        }
        enum teams {
            static let name = "name"
            static let users = "users"
            static let documentID = ""
            static let skillAge = "skill_age"
            static let skillName = "name"
            static let skillColor = "color_hex"
            static let technologies = "technologies"
        }
        enum users {
            static let name = "name"
            static let icon = "icon"
            static let skills = "skills"
            static let skillsName = "name"
            static let skillsTime = "years"
            static let busy = "busy"
            static let standardWeeklyEmploymentValue: CGFloat = 40
        }
    }
    enum mainFireStoreCollections {
        static let technology = "Technology"
        static let teams = "Teams"
        static let users = "Users"
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
        static let inviteUserViewController = "InvaiteUserViewController"
        static let employeesViewController = "EmployeesViewController"
    }
    
    enum cellsID {
        static let technologyTableViewCell = "TechnologyTableViewCell"
        static let teamTableViewCell = "TeamTableViewCell"
        static let teamMemberTableViewCell = "TeamMemberTableViewCell"
        static let chooseTechnologyTableViewCell = "ChooseTechnologyTableViewCell"
        static let employeesTableViewCell = "EmployeesTableViewCell"
        static let tagCollectionViewCell = "TagCollectionViewCell"
        static let InvaiteUserTableViewCell = "InvaiteUserTableViewCell"
    }
}
