//
//  UserModel.swift
//  FireBrick
//
//  Created by metoSimka on 28/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var name: String?
    var imageLink: String?
    var hoursInWeek: Int?
    var skills: [[String: AnyObject]]?
    var teamDocumentID: String?
    var busy: Int?
}
