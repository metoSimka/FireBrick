//
//  ProjectModel.swift
//  FireBrick
//
//  Created by metoSimka on 07/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import Foundation
import UIKit

struct Project {
    var name: String?
    var imageLink: String?
    var endDate: String?
    var startDate: String?
    var hours: Int?
    var users: [User]?
    var technologies: [Technology]?
}
